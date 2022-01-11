%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(log). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
	 log/1,
	 store_alert/1,
	 store_ticket/1,
	 store_info/1,
	 read_all/0,
	 read_all/1,
	 read_alert/0,
	 read_alert/1,
	 read_ticket/0,
	 read_ticket/1,
	 read_info/0,
	 read_info/1,

	 boot/0
	]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([start/0,
	 stop/0]).
%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER,log_server).
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
%% --------------------------------------------------------------------
boot()->
    application:start(?SERVER).


%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%% --------------------------------------------------------------------
start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).


log(Info)-> 
    gen_server:cast(?SERVER, {log,Info}).

store_alert(Info)-> 
    gen_server:cast(?SERVER, {alert,Info}).
store_ticket(Info)->
    gen_server:cast(?SERVER, {ticket,Info}).
store_info(Info)->
    gen_server:cast(?SERVER, {info,Info}).

read_all()-> 
    gen_server:call(?SERVER, {read_all},infinity).
read_all(NumLatesInfo)->
    gen_server:call(?SERVER, {read_all,NumLatesInfo},infinity).
read_alert()->
    gen_server:call(?SERVER, {read_alert},infinity).
read_alert(NumLatesInfo)->
    gen_server:call(?SERVER, {read_alert,NumLatesInfo},infinity).
read_ticket()->
    gen_server:call(?SERVER, {read_ticket},infinity).
read_ticket(NumLatesInfo)->
    gen_server:call(?SERVER, {read_ticket,NumLatesInfo},infinity).
read_info()->
    gen_server:call(?SERVER, {read_info},infinity).
read_info(NumLatesInfo)->
    gen_server:call(?SERVER, {read_info,NumLatesInfo},infinity).

%% ====================================================================
%% Internal functions
%% ====================================================================

