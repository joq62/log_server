all:
#	service
	rm -rf ebin/* *_ebin;
	rm -rf src/*.beam *.beam  test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
	rm -rf *_specs *_config *.log;
#	common
#	cp ../common/src/*.app ebin;
	erlc -I ../../include -I include -o ebin ../../common/src/*.erl;
#	app
	erlc -I ../../include -I include -o ebin src/*.erl;
	echo Done
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
	mkdir test_ebin;
#	common
#	cp ../common/src/*.app ebin;
	erlc -I ../../include -I include -o ebin ../../common/src/*.erl;
#	sd
	erlc -I ../../include -D unit_test -I include  -o ebin ../sd/src/*.erl;
#	dbase
	erlc -I ../../include -D unit_test -I include  -I ../controller/include -I ../dbase_server/include -o ebin ../dbase_server/src/*.erl;
#	log_server
	erlc -D unit_test -I ../../include -I include  -I ../controller/include -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -D debug_flag -I ../../include -I include -I ../controller/include -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie_test\
	    -sname test\
	    -unit_test monitor_node test\
	    -unit_test cluster_id test\
	    -unit_test cookie cookie_test\
	    -run unit_test start_test test_src/test.config
