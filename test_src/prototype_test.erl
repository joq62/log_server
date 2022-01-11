%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(prototype_test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
  %  io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
    io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start init()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=init(),
    io:format("~p~n",[{"Stop init()",?MODULE,?FUNCTION_NAME,?LINE}]),

  %  io:format("~p~n",[{"Start stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),
  %  ok= stop_restart(),
  %  io:format("~p~n",[{"Stop  stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   
      %% End application tests
  %  io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
  %  io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.
 %  io:format("application:which ~p~n",[{application:which_applications(),?FUNCTION_NAME,?MODULE,?LINE}]),

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
init()->
    L1=?Log_alert("test1",["Makefile","glurk"]),
    L2=?Log_alert("test2",[120,76]),
    L3=?Log_ticket("test3",[42]),
    L4=?Log_info("server started",[{?MODULE,?LINE,?FUNCTION_NAME}]),

    ok=db_log:create(L1),
    ok=db_log:create(L2),
    ok=db_log:create(L3),
    ok=db_log:create(L4),
       
    ok=log:read_all(),

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



  
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
get_nodes()->
    HostId=net_adm:localhost(),
    A="host0@"++HostId,
    Node0=list_to_atom(A),
    B="host1@"++HostId,
    Node1=list_to_atom(B),
    C="host2@"++HostId,
    Node2=list_to_atom(C),    
    [Node0,Node1,Node2].
    
start_slave(NodeName)->
    HostId=net_adm:localhost(),
    Node=list_to_atom(NodeName++"@"++HostId),
    rpc:call(Node,init,stop,[]),
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-pa ebin -pa test_ebin -setcookie "++Cookie,
    {ok,SNode}=slave:start(HostId,NodeName,Args),
    [net_adm:ping(N)||N<-nodes()],
    {ok,SNode}.

setup()->
    HostId=net_adm:localhost(),
    A="host0@"++HostId,
    Node0=list_to_atom(A),
    B="host1@"++HostId,
    Node1=list_to_atom(B),
    C="host2@"++HostId,
    Node2=list_to_atom(C),    
    Nodes=[Node0,Node1,Node2],
    [rpc:call(N,init,stop,[],5*1000)||N<-Nodes],
    timer:sleep(2000),
    [{ok,Node0},
     {ok,Node1},
     {ok,Node2}]=[start_slave(NodeName)||NodeName<-["host0","host1","host2"]],
    [net_adm:ping(N)||N<-Nodes],
    {ok,_}=sd:start(),
    application:set_env([{dbase_infra,[{dbase_app,dbase_infra}]}]),
    ok=application:start(dbase_infra),
    {ok,_}=log:start(),
    
   
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
    mnesia:stop(),
    mnesia:del_table_copy(schema,node()),
    mnesia:delete_schema([node()]),
    timer:sleep(1000),
    [slave:stop(Node)||Node<-get_nodes()],
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
