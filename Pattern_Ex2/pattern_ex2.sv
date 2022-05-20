`timescale 1ns/10ps
module PATTERN(
  // Output signals
	clk,
	rst_n,
    in_valid,
    in,
  // input signals
	out_valid,
	out
);
//================================================================
// wire & registers 
//================================================================

output logic clk,rst_n,in_valid;
output logic signed [3:0] in;
input [3:0] out;
input out_valid;

//================================================================
// parameters & integer
//================================================================
integer PATNUM=1000;
integer input_file,output_file;
integer count;
integer check_count;
integer i,j,k,y;
integer patcount;
integer cycle_time;
integer lat;
integer CYCLE = 5;

always	#(CYCLE/2.0) clk = ~clk;
logic signed [3:0] in_temp [0:19];
logic signed [3:0] golden_in [0:4];

//================================================================
// initial
//================================================================
initial begin
    clk = 0;
    rst_n = 1'b1;
    in_valid = 0;
    in = 4'bx;
	reset_task;
    for(patcount = 0 ; patcount < PATNUM ; patcount = patcount + 1) begin
        for(i = 0; i<20 ; i = i + 1) begin
        in_valid = 1;
        in = $urandom_range(7,-8);
        if(in < 0)
        in_temp[i] = 0;
        else
        in_temp[i] = in;
        @(negedge clk);
        end
        in = 4'bx;
        in_valid = 0;
        ans_gen;
        wait_outvalid;
        ans_check;
    end
    YOU_PASS_task;
end
//================================================================
// task
//================================================================
task ans_gen; begin
    
    for(j=0; j<5; j=j+1) begin
    golden_in[j] = 0;
        for(k=0; k<4; k=k+1) begin
        if (in_temp[4*j+k] > golden_in[j]) begin
           golden_in[j] = in_temp[4*j+k];
        end
        else
           golden_in[j] = golden_in[j];
        end       
    end
        
end endtask

task ans_check; begin
	y=0;
	while(out_valid === 1)
	begin
	    //check_monitor;
		if(y>=5)
			begin
			    fail;
				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				$display ("                                                                        FAIL!                                                               ");
				$display ("                                                           Outvalid is more than 5 cycles                                                   ");
				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				repeat(6) @(negedge clk);
				$finish;
			end
        if(y == 0) begin
		if(out!==golden_in[0])
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        FAIL!                                                               ");
					$display ("                                                                   PATTERN NO.%4d                                                           ",patcount);
					$display ("                                                     Ans(out_pixel1): %d,  Your output : %d  at %8t                                              ",golden_in[0],out,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(6) @(negedge clk);
					$finish;
				end
        end
        if(y == 1) begin
		if(out!==golden_in[1])
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        FAIL!                                                               ");
					$display ("                                                                   PATTERN NO.%4d                                                           ",patcount);
					$display ("                                                     Ans(out_pixel2): %d,  Your output : %d  at %8t                                              ",golden_in[1],out,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(6) @(negedge clk);
					$finish;
				end
        end
        if(y== 2) begin
		if(out!==golden_in[2])
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        FAIL!                                                               ");
					$display ("                                                                   PATTERN NO.%4d                                                           ",patcount);
					$display ("                                                     Ans(out_pixel3): %d,  Your output : %d  at %8t                                              ",golden_in[2],out,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(6) @(negedge clk);
					$finish;
				end
                end
        if(y == 3) begin              
		if(out!==golden_in[3])
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        FAIL!                                                               ");
					$display ("                                                                   PATTERN NO.%4d                                                           ",patcount);
					$display ("                                                     Ans(out_pixel4): %d,  Your output : %d  at %8t                                              ",golden_in[3],out,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(6) @(negedge clk);
					$finish;
				end
                end
        if(y==4) begin
		if(out!==golden_in[4])
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        FAIL!                                                               ");
					$display ("                                                                   PATTERN NO.%4d                                                           ",patcount);
					$display ("                                                     Ans(out_pixel5): %d,  Your output : %d  at %8t                                              ",golden_in[4],out,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(6) @(negedge clk);
					$finish;
				end
                end
		repeat(1)@(negedge clk);	
		y=y+1;
        
	end		
	
	if(y < 4)
		begin
			fail;
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                         outvalid is less than 5 cycle                                                     ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(6) @(negedge clk);
			$finish;
		end		
end endtask
task wait_outvalid ; begin
	lat = -1;
	while(out_valid !== 1)begin
		lat = lat+1;
		if(lat == 100) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                     The execution latency are over 100  cycles                                            ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(2)@(negedge clk);
			$finish;
		end
	@(negedge clk);
	end
	
end endtask


task reset_task ; begin
    @(negedge clk);
    #(1.0) ; rst_n = 0;

	#(2.0);
	  if( ( out !== 0 ) || (out_valid !==0) )
	  begin
       $display("----------------------------" );
       $display("            FAIL            " );
	   $display(" out should be 0 after rst  " );
       $display("----------------------------" );
	   $finish ;
	  end 
	
	#(CYCLE*3) rst_n = 1 ;
    @(negedge clk);
end endtask

task YOU_PASS_task;begin
  $display("                                                             \033[33m`-                                                                            ");        
  $display("                                                             /NN.                                                                           ");        
  $display("                                                            sMMM+                                                                           ");        
  $display(" .``                                                       sMMMMy                                                                           ");        
  $display(" oNNmhs+:-`                                               oMMMMMh                                                                           ");        
  $display("  /mMMMMMNNd/:-`                                         :+smMMMh                                                                           ");        
  $display("   .sNMMMMMN::://:-`                                    .o--:sNMy                                                                           ");        
  $display("     -yNMMMM:----::/:-.                                 o:----/mo                                                                           ");        
  $display("       -yNMMo--------://:.                             -+------+/                                                                           ");        
  $display("         .omd/::--------://:`                          o-------o.                                                                           ");        
  $display("           `/+o+//::-------:+:`                       .+-------y                                                                            ");        
  $display("              .:+++//::------:+/.---------.`          +:------/+                                                                            ");        
  $display("                 `-/+++/::----:/:::::::::::://:-.     o------:s.          \033[37m:::::----.           -::::.          `-:////:-`     `.:////:-.    \033[33m");        
  $display("                    `.:///+/------------------:::/:- `o-----:/o          \033[37m.NNNNNNNNNNds-       -NNNNNd`       -smNMMMMMMNy   .smNNMMMMMNh    \033[33m");        
  $display("                         :+:----------------------::/:s-----/s.          \033[37m.MMMMo++sdMMMN-     `mMMmMMMs      -NMMMh+///oys  `mMMMdo///oyy    \033[33m");        
  $display("                        :/---------------------------:++:--/++           \033[37m.MMMM.   `mMMMy     yMMM:dMMM/     +MMMM:      `  :MMMM+`     `    \033[33m");        
  $display("                       :/---///:-----------------------::-/+o`           \033[37m.MMMM.   -NMMMo    +MMMs -NMMm.    .mMMMNdo:.     `dMMMNds/-`      \033[33m");        
  $display("                      -+--/dNs-o/------------------------:+o`            \033[37m.MMMMyyyhNMMNy`   -NMMm`  sMMMh     .odNMMMMNd+`   `+dNMMMMNdo.    \033[33m");        
  $display("                     .o---yMMdsdo------------------------:s`             \033[37m.MMMMNmmmdho-    `dMMMdooosMMMM+      `./sdNMMMd.    `.:ohNMMMm-   \033[33m");        
  $display("                    -yo:--/hmmds:----------------//:------o              \033[37m.MMMM:...`       sMMMMMMMMMMMMMN-  ``     `:MMMM+ ``      -NMMMs   \033[33m");        
  $display("                   /yssy----:::-------o+-------/h/-hy:---:+              \033[37m.MMMM.          /MMMN:------hMMMd` +dy+:::/yMMMN- :my+:::/sMMMM/   \033[33m");        
  $display("                  :ysssh:------//////++/-------sMdyNMo---o.              \033[37m.MMMM.         .mMMMs       .NMMMs /NMMMMMMMMmh:  -NMMMMMMMMNh/    \033[33m");        
  $display("                  ossssh:-------ddddmmmds/:----:hmNNh:---o               \033[37m`::::`         .::::`        -:::: `-:/++++/-.     .:/++++/-.      \033[33m");        
  $display("                  /yssyo--------dhhyyhhdmmhy+:---://----+-                                                                                  ");        
  $display("                  `yss+---------hoo++oosydms----------::s    `.....-.                                                                       ");        
  $display("                   :+-----------y+++++++oho--------:+sssy.://:::://+o.                                                                      ");        
  $display("                    //----------y++++++os/--------+yssssy/:--------:/s-                                                                     ");        
  $display("             `..:::::s+//:::----+s+++ooo:--------+yssssy:-----------++                                                                      ");        
  $display("           `://::------::///+/:--+soo+:----------ssssys/---------:o+s.``                                                                    ");        
  $display("          .+:----------------/++/:---------------:sys+----------:o/////////::::-...`                                                        ");        
  $display("          o---------------------oo::----------::/+//---------::o+--------------:/ohdhyo/-.``                                                ");        
  $display("          o---------------------/s+////:----:://:---------::/+h/------------------:oNMMMMNmhs+:.`                                           ");        
  $display("          -+:::::--------------:s+-:::-----------------:://++:s--::------------::://sMMMMMMMMMMNds/`                                        ");        
  $display("           .+++/////////////+++s/:------------------:://+++- :+--////::------/ydmNNMMMMMMMMMMMMMMmo`                                        ");        
  $display("             ./+oo+++oooo++/:---------------------:///++/-   o--:///////::----sNMMMMMMMMMMMMMMMmo.                                          ");        
  $display("                o::::::--------------------------:/+++:`    .o--////////////:--+mMMMMMMMMMMMMmo`                                            ");        
  $display("               :+--------------------------------/so.       +:-:////+++++///++//+mMMMMMMMMMmo`                                              ");        
  $display("              .s----------------------------------+: ````` `s--////o:.-:/+syddmNMMMMMMMMMmo`                                                ");        
  $display("              o:----------------------------------s. :s+/////--//+o-       `-:+shmNNMMMNs.                                                  ");        
  $display("             //-----------------------------------s` .s///:---:/+o.               `-/+o.                                                    ");        
  $display("            .o------------------------------------o.  y///+//:/+o`                                                                          ");        
  $display("            o-------------------------------------:/  o+//s//+++`                                                                           ");        
  $display("           //--------------------------------------s+/o+//s`                                                                                ");        
  $display("          -+---------------------------------------:y++///s                                                                                 ");        
  $display("          o-----------------------------------------oo/+++o                                                                                 ");        
  $display("         `s-----------------------------------------:s   ``                                                                                 ");        
  $display("          o-:::::------------------:::::-------------o.                                                                                     ");        
  $display("          .+//////////::::::://///////////////:::----o`                                                                                     ");        
  $display("          `:soo+///////////+++oooooo+/////////////:-//                                                                                      ");        
  $display("       -/os/--:++/+ooo:::---..:://+ooooo++///////++so-`                                                                                     ");        
  $display("      syyooo+o++//::-                 ``-::/yoooo+/:::+s/.                                                                                  ");        
  $display("       `..``                                `-::::///:++sys:                                                                                ");        
  $display("                                                    `.:::/o+  \033[37m                                                                              ");											  
	$display ("--------------------------------------------------------------------------------------------------------------------------------------------");                                                                      
	$display ("                                                            Congratulations!                                                                ");
	$display ("                                                     You have passed all patterns!                                                          ");
	$display ("--------------------------------------------------------------------------------------------------------------------------------------------");    
	$finish;	
end endtask



task fail; begin


$display("\033[33m	                                                         .:                                                                                         ");      
$display("                                                   .:                                                                                                 ");
$display("                                                  --`                                                                                                 ");
$display("                                                `--`                                                                                                  ");
$display("                 `-.                            -..        .-//-                                                                                      ");
$display("                  `.:.`                        -.-     `:+yhddddo.                                                                                    ");
$display("                    `-:-`             `       .-.`   -ohdddddddddh:                                                                                   ");
$display("                      `---`       `.://:-.    :`- `:ydddddhhsshdddh-                       \033[31m.yhhhhhhhhhs       /yyyyy`       .yhhy`   +yhyo           \033[33m");
$display("                        `--.     ./////:-::` `-.--yddddhs+//::/hdddy`                      \033[31m-MMMMNNNNNNh      -NMMMMMs       .MMMM.   sMMMh           \033[33m");
$display("                          .-..   ////:-..-// :.:oddddho:----:::+dddd+                      \033[31m-MMMM-......     `dMMmhMMM/      .MMMM.   sMMMh           \033[33m");
$display("                           `-.-` ///::::/::/:/`odddho:-------:::sdddh`                     \033[31m-MMMM.           sMMM/.NMMN.     .MMMM.   sMMMh           \033[33m");
$display("             `:/+++//:--.``  .--..+----::://o:`osss/-.--------::/dddd/             ..`     \033[31m-MMMMysssss.    /MMMh  oMMMh     .MMMM.   sMMMh           \033[33m");
$display("             oddddddddddhhhyo///.-/:-::--//+o-`:``````...------::dddds          `.-.`      \033[31m-MMMMMMMMMM-   .NMMN-``.mMMM+    .MMMM.   sMMMh           \033[33m");
$display("            .ddddhhhhhddddddddddo.//::--:///+/`.````````..``...-:ddddh       `.-.`         \033[31m-MMMM:.....`  `hMMMMmmmmNMMMN-   .MMMM.   sMMMh           \033[33m");
$display("            /dddd//::///+syhhdy+:-`-/--/////+o```````.-.......``./yddd`   `.--.`           \033[31m-MMMM.        oMMMmhhhhhhdMMMd`  .MMMM.   sMMMh```````    \033[33m");
$display("            /dddd:/------:://-.`````-/+////+o:`````..``     `.-.``./ym.`..--`              \033[31m-MMMM.       :NMMM:      .NMMMs  .MMMM.   sMMMNmmmmmms    \033[33m");
$display("            :dddd//--------.`````````.:/+++/.`````.` `.-      `-:.``.o:---`                \033[31m.dddd`       yddds        /dddh. .dddd`   +ddddddddddo    \033[33m");
$display("            .ddddo/-----..`........`````..```````..  .-o`       `:.`.--/-      ``````````` \033[31m ````        ````          ````   ````     ``````````     \033[33m");
$display("             ydddh/:---..--.````.`.-.````````````-   `yd:        `:.`...:` `................`                                                         ");
$display("             :dddds:--..:.     `.:  .-``````````.:    +ys         :-````.:...```````````````..`                                                       ");
$display("              sdddds:.`/`      ``s.  `-`````````-/.   .sy`      .:.``````-`````..-.-:-.````..`-                                                       ");
$display("              `ydddd-`.:       `sh+   /:``````````..`` +y`   `.--````````-..---..``.+::-.-``--:                                                       ");
$display("               .yddh``-.        oys`  /.``````````````.-:.`.-..`..```````/--.`      /:::-:..--`                                                       ");
$display("                .sdo``:`        .sy. .:``````````````````````````.:```...+.``       -::::-`.`                                                         ");
$display(" ````.........```.++``-:`        :y:.-``````````````....``.......-.```..::::----.```  ``                                                              ");
$display("`...````..`....----:.``...````  ``::.``````.-:/+oosssyyy:`.yyh-..`````.:` ````...-----..`                                                             ");
$display("                 `.+.``````........````.:+syhdddddddddddhoyddh.``````--              `..--.`                                                          ");
$display("            ``.....--```````.```````.../ddddddhhyyyyyyyhhhddds````.--`             ````   ``                                                          ");
$display("         `.-..``````-.`````.-.`.../ss/.oddhhyssssooooooossyyd:``.-:.         `-//::/++/:::.`                                                          ");
$display("       `..```````...-::`````.-....+hddhhhyssoo+++//////++osss.-:-.           /++++o++//s+++/                                                          ");
$display("     `-.```````-:-....-/-``````````:hddhsso++/////////////+oo+:`             +++::/o:::s+::o            \033[31m     `-/++++:-`                              \033[33m");
$display("    `:````````./`  `.----:..````````.oysso+///////////////++:::.             :++//+++/+++/+-            \033[31m   :ymMMMMMMMMms-                            \033[33m");
$display("    :.`-`..```./.`----.`  .----..`````-oo+////////////////o:-.`-.            `+++++++++++/.             \033[31m `yMMMNho++odMMMNo                           \033[33m");
$display("    ..`:..-.`.-:-::.`        `..-:::::--/+++////////////++:-.```-`            +++++++++o:               \033[31m hMMMm-      /MMMMo  .ssss`/yh+.syyyyyyyyss. \033[33m");
$display("     `.-::-:..-:-.`                 ```.+::/++//++++++++:..``````:`          -++++++++oo                \033[31m:MMMM:        yMMMN  -MMMMdMNNs-mNNNNNMMMMd` \033[33m");
$display("        `   `--`                        /``...-::///::-.`````````.: `......` ++++++++oy-                \033[31m+MMMM`        +MMMN` -MMMMh:--. ````:mMMNs`  \033[33m");
$display("           --`                          /`````````````````````````/-.``````.::-::::::/+                 \033[31m:MMMM:        yMMMm  -MMMM`       `oNMMd:    \033[33m");
$display("          .`                            :```````````````````````--.`````````..````.``/-                 \033[31m dMMMm:`    `+MMMN/  -MMMN       :dMMNs`     \033[33m");
$display("                                        :``````````````````````-.``.....````.```-::-.+                  \033[31m `yNMMMdsooymMMMm/   -MMMN     `sMMMMy/////` \033[33m");
$display("                                        :.````````````````````````-:::-::.`````-:::::+::-.`             \033[31m   -smNMMMMMNNd+`    -NNNN     hNNNNNNNNNNN- \033[33m");
$display("                                `......../```````````````````````-:/:   `--.```.://.o++++++/.           \033[31m      .:///:-`       `----     ------------` \033[33m");
$display("                              `:.``````````````````````````````.-:-`      `/````..`+sssso++++:                                                        ");
$display("                              :`````.---...`````````````````.--:-`         :-````./ysoooss++++.                                                       ");
$display("                              -.````-:/.`.--:--....````...--:/-`            /-..-+oo+++++o++++.                                                       ");
$display("             `:++/:.`          -.```.::      `.--:::::://:::::.              -:/o++++++++s++++                                                        ");
$display("           `-+++++++++////:::/-.:.```.:-.`              :::::-.-`               -+++++++o++++.                                                        ");
$display("           /++osoooo+++++++++:`````````.-::.             .::::.`-.`              `/oooo+++++.                                                         ");
$display("           ++oysssosyssssooo/.........---:::               -:::.``.....`     `.:/+++++++++:                                                           ");
$display("           -+syoooyssssssyo/::/+++++/+::::-`                 -::.``````....../++++++++++:`                                                            ");
$display("             .:///-....---.-..-.----..`                        `.--.``````````++++++/:.                                                               ");
$display("                                                                   `........-:+/:-.`                                                            \033[37m      ");


		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                  FAIL                                                                      ");
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");


end endtask


endmodule


