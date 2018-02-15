Deploying our project to an Ubuntu server means understanding the three pieces that
primarily compose it:
1. the Front-end, or the files Index.html, Comparison.html, Overview.html, and style.css.
2. the Scripting, or Query.pl and Overview.pl
3. the Back-end, or Main.pl, GFF_GTF_Parser.pm, Annotation.pm

Here are the steps to deploying the software:
1. Place the Back-end files on the server. Run the back-end first by running Main.pl with 
one single argument: the GFF file. Our system only supports this file format for now. Because 
the GFF file doesn't contain the name of your organism, you'll need to type it into the 
code manually (in Main.pl) before you run it.
	a. This only needs to run ONCE just to populate your databases.
	NOTE: Our databases were created via the phpMyAdmin UI. We suggest you create tables
	with the same attributes. Our create statements can be found in our 3-page-report.

2. Next, deposit all of the Front-end files in the public_html directory of your server.
They will now be accessible via the URL your-server-name/...
3. Finally, deposit the Scripting files in the same directory (at the same level) of your
public_html. Your webpages will now have the ability to query the database.
	NOTE: 

That's all there is to it. 