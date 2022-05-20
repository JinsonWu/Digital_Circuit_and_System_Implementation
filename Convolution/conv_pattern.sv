`timescale 100ps/10ps
module PATTERN(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);
output logic clk, rst_n, image_valid, filter_valid;
output logic signed [3:0] in_data;
input     out_valid;
input signed [10:0]out_data;
logic signed [10:0]out_answer;
//================================================================
// parameters & integer
//================================================================
integer CYCLE = 7;
integer total_lat;
integer counter;
integer y;
integer filter_in;
integer image_in;
integer out_in;
integer s1, s2, s3, number;
always # (CYCLE/2.0) clk = ~clk;

//================================================================
// initial
//================================================================
initial begin
  filter_in = $fopen("filter.txt","r");
  image_in  = $fopen("input.txt","r");  
  out_in    = $fopen("output.txt","r");
    image_valid = 0;
  filter_valid = 0;
  rst_n = 1'b1;
  counter = 0;
  in_data = 0;
  number =0;
    force clk = 0;
    reset;
  repeat (3) @ (posedge clk);
    rst_n = 1'b1;
  @ (negedge clk);
  while (!$feof(filter_in)) begin
    @ (negedge clk);
    filter_valid = 1;
    //in_data = $fscanf(filter_in,"%d",dfilter_in[3:0]);
     s1=$fscanf(filter_in,"%d",in_data);
  end 
  filter_valid = 0;
  while (!$feof(image_in)) begin
    @ (negedge clk);
    image_valid = 1;
    s2=$fscanf(image_in,"%d",in_data);
  end
  in_data =0;
  image_valid = 0;
  @ (negedge clk);
    wait_outvalid;
  while (!$feof(out_in)) begin    
    @ (posedge clk);
    s3=$fscanf(out_in,"%d",out_answer);
    number = number+1;
    if (number ==26) out_answer =0;
    check;  
  end
  out_re;
  $fclose(filter_in);
  $fclose(image_in);
  $fclose(out_in);
    YOU_PASS_task;
end

//================================================================
// task
//================================================================
task check;begin
//  while (out_valid !== 0)begin
    if (out_data !== out_answer)begin
      fail;
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $display ("                                                                        SPEC4!                                                               ");
      $display ("                                                                       YOUR:  %d                                      ",out_data);
      $display ("                                                                      GOLDEN: %d                                      ",out_answer);
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $finish;     
    end
 //   end
end 
endtask

task out_re; begin
  y=0;
  while (out_valid !== 0)begin
    if (y==0) y = y + 1;
    else if (y >=1)begin
       fail;
       $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
       $display ("                                                                        SPEC2!                                                               ");
       $display ("                                                           Output should be zero after check                                                  ");
       $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
       $finish;
    end
  end
end
endtask

task wait_outvalid;begin
  total_lat = -1;
  while (out_valid !== 1)begin
  if (total_lat < 100)
    total_lat = total_lat +1;
    else if (total_lat == 100)begin
    fail;
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $display ("                                                                        SPEC3!                                                               ");
      $display ("                                                     The execution latency are over 100  cycles                                            ");
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $finish;
    end
    @(negedge clk);
  end
end
endtask

task reset;begin
  #( 0.5 ); rst_n = 0;

  #(2.0);
    if (out_data !== 0 || out_valid !== 0)begin
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $display ("                                                                        SPEC1!                                                               ");
      $display ("                                                                        Reset                                                                ");
      $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
      $finish;
    end
  #(10) rst_n = 1 ;
    #(3) release clk;
end
endtask








task fail; begin


$display("\033[33m                                                           .:                                                                                         ");      
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
    $display ("                                                       latency:  %d                                      ",total_lat*CYCLE);
  $display ("--------------------------------------------------------------------------------------------------------------------------------------------");    
  $finish;
end endtask



endmodule


