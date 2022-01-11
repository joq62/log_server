%% Author: joqerlang
%% Created: 2021-11-18 
%% Connect/keep connections to other nodes
%% clean up of computer (removes all applications but keeps log file
%% git loads or remove an application ,loadand start application
%%  
%% Starts either as controller or worker node, given in application env 
%% Controller:
%%   git clone and starts 
%% 
%% Description: TODO: Add description to application_org
%% 
-module(lib_log).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
	 nice_print/1,
	 store/1,
	 read_all/0,
	 read_all/1
        ]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% API Functions
%% --------------------------------------------------------------------

%% ====================================================================!
%% External functions
%% ====================================================================!
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%%---------------------------------------------------------------------
nice_print(Id)->
   
    case db_log:read(Id) of
	{aborted,Reason}->
	    {error,Reason};
	Info->
	    {Id,SystemTime,Node,Severity,Msg,Module,Function,Line,Args,Status}=Info,
	    Time=calendar:system_time_to_rfc3339(SystemTime,                
						 [{unit, ?SystemTime}, {time_designator, $\s}, {offset, "Z"}]),

	    Node1=atom_to_list(Node),
	    Severity1=" "++Severity,
	    Module1=atom_to_list(Module),
	    Function1=atom_to_list(Function),
	    Line1=integer_to_list(Line),
	    Status1=atom_to_list(Status),
	    Msg1=" "++Msg,
	    MF=" "++Module1++":"++Function1,

	  %  io:format("MF ~p~n",[{Id,?MODULE,?FUNCTION_NAME,?LINE}]),	    
	    io:format("~s ~s ~s",[Time,Msg1,MF]),
	    io:format(" ["),
	    print(Args),
	    io:format("] "),
	    io:format("Line=~s Node=~s",[Line1,Node1]),
	    io:format("~n")
    end.

print([])->
    ok;
print([Arg|T]) ->
    io:format("~p",[Arg]),
    case T of
	[]->
	    ok;
	_ ->
	    io:format(",")
    end,
    print(T).
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%%---------------------------------------------------------------------
store(Info)->
    ok=rpc:call(node(),db_log,create,[Info],5*1000),
    ok.

read_all()->
    N=node(),
    Info=rpc:call(N,mnesia,dirty_all_keys,[logger_info],5*1000),
    SortedList=lists:reverse(lists:sort(Info)),
    [rpc:call(N,lib_log,nice_print,[Id],3*1000)||Id<-SortedList],
    ok.
read_all(NumLatesInfo)->
    N=node(),
    Info=rpc:call(N,mnesia,dirty_all_keys,[logger_info],5*1000),
    SortedList=lists:reverse(lists:sort(Info)),
    [rpc:call(N,lib_log,nice_print,[Id],3*1000)||Id<-lists:sublist(SortedList,NumLatesInfo)],
    ok.
