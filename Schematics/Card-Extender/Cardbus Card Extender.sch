<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="6.5.0">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="2" name="Route2" color="1" fill="3" visible="no" active="no"/>
<layer number="3" name="Route3" color="4" fill="3" visible="no" active="no"/>
<layer number="4" name="Route4" color="1" fill="4" visible="no" active="no"/>
<layer number="5" name="Route5" color="4" fill="4" visible="no" active="no"/>
<layer number="6" name="Route6" color="1" fill="8" visible="no" active="no"/>
<layer number="7" name="Route7" color="4" fill="8" visible="no" active="no"/>
<layer number="8" name="Route8" color="1" fill="2" visible="no" active="no"/>
<layer number="9" name="Route9" color="4" fill="2" visible="no" active="no"/>
<layer number="10" name="Route10" color="1" fill="7" visible="no" active="no"/>
<layer number="11" name="Route11" color="4" fill="7" visible="no" active="no"/>
<layer number="12" name="Route12" color="1" fill="5" visible="no" active="no"/>
<layer number="13" name="Route13" color="4" fill="5" visible="no" active="no"/>
<layer number="14" name="Route14" color="1" fill="6" visible="no" active="no"/>
<layer number="15" name="Route15" color="4" fill="6" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="pinhead">
<description>&lt;b&gt;Pin Header Connectors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="2X20">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-25.4" y1="-1.905" x2="-24.765" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-24.765" y1="-2.54" x2="-23.495" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-23.495" y1="-2.54" x2="-22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-1.905" x2="-22.225" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-22.225" y1="-2.54" x2="-20.955" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-20.955" y1="-2.54" x2="-20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-1.905" x2="-19.685" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-19.685" y1="-2.54" x2="-18.415" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-18.415" y1="-2.54" x2="-17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="-1.905" x2="-17.145" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-17.145" y1="-2.54" x2="-15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-15.875" y1="-2.54" x2="-15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-1.905" x2="-14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-14.605" y1="-2.54" x2="-13.335" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-13.335" y1="-2.54" x2="-12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-1.905" x2="-12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-12.065" y1="-2.54" x2="-10.795" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-10.795" y1="-2.54" x2="-10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="-1.905" x2="-25.4" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="1.905" x2="-24.765" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-24.765" y1="2.54" x2="-23.495" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-23.495" y1="2.54" x2="-22.86" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="1.905" x2="-22.225" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-22.225" y1="2.54" x2="-20.955" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-20.955" y1="2.54" x2="-20.32" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="1.905" x2="-19.685" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-19.685" y1="2.54" x2="-18.415" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-18.415" y1="2.54" x2="-17.78" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="1.905" x2="-17.145" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-17.145" y1="2.54" x2="-15.875" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-15.875" y1="2.54" x2="-15.24" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="1.905" x2="-14.605" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-14.605" y1="2.54" x2="-13.335" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-13.335" y1="2.54" x2="-12.7" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="1.905" x2="-12.065" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-12.065" y1="2.54" x2="-10.795" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-10.795" y1="2.54" x2="-10.16" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="1.905" x2="-9.525" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-9.525" y1="2.54" x2="-8.255" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-8.255" y1="2.54" x2="-7.62" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="1.905" x2="-6.985" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-6.985" y1="2.54" x2="-5.715" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-5.715" y1="2.54" x2="-5.08" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="1.905" x2="-4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="2.54" x2="-3.175" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="2.54" x2="-2.54" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="1.905" x2="-1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="2.54" x2="-0.635" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="2.54" x2="0" y2="1.905" width="0.1524" layer="21"/>
<wire x1="0" y1="1.905" x2="0.635" y2="2.54" width="0.1524" layer="21"/>
<wire x1="0.635" y1="2.54" x2="1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="1.905" y1="2.54" x2="2.54" y2="1.905" width="0.1524" layer="21"/>
<wire x1="2.54" y1="1.905" x2="3.175" y2="2.54" width="0.1524" layer="21"/>
<wire x1="3.175" y1="2.54" x2="4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="5.08" y1="1.905" x2="4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="5.08" y1="1.905" x2="5.715" y2="2.54" width="0.1524" layer="21"/>
<wire x1="6.985" y1="2.54" x2="5.715" y2="2.54" width="0.1524" layer="21"/>
<wire x1="6.985" y1="2.54" x2="7.62" y2="1.905" width="0.1524" layer="21"/>
<wire x1="7.62" y1="1.905" x2="8.255" y2="2.54" width="0.1524" layer="21"/>
<wire x1="9.525" y1="2.54" x2="8.255" y2="2.54" width="0.1524" layer="21"/>
<wire x1="9.525" y1="2.54" x2="10.16" y2="1.905" width="0.1524" layer="21"/>
<wire x1="10.16" y1="1.905" x2="10.795" y2="2.54" width="0.1524" layer="21"/>
<wire x1="12.065" y1="2.54" x2="10.795" y2="2.54" width="0.1524" layer="21"/>
<wire x1="12.065" y1="2.54" x2="12.7" y2="1.905" width="0.1524" layer="21"/>
<wire x1="12.7" y1="1.905" x2="13.335" y2="2.54" width="0.1524" layer="21"/>
<wire x1="14.605" y1="2.54" x2="13.335" y2="2.54" width="0.1524" layer="21"/>
<wire x1="14.605" y1="2.54" x2="15.24" y2="1.905" width="0.1524" layer="21"/>
<wire x1="15.24" y1="1.905" x2="15.875" y2="2.54" width="0.1524" layer="21"/>
<wire x1="17.145" y1="2.54" x2="15.875" y2="2.54" width="0.1524" layer="21"/>
<wire x1="17.145" y1="2.54" x2="17.78" y2="1.905" width="0.1524" layer="21"/>
<wire x1="17.78" y1="1.905" x2="18.415" y2="2.54" width="0.1524" layer="21"/>
<wire x1="19.685" y1="2.54" x2="18.415" y2="2.54" width="0.1524" layer="21"/>
<wire x1="19.685" y1="2.54" x2="20.32" y2="1.905" width="0.1524" layer="21"/>
<wire x1="20.32" y1="1.905" x2="20.955" y2="2.54" width="0.1524" layer="21"/>
<wire x1="22.225" y1="2.54" x2="20.955" y2="2.54" width="0.1524" layer="21"/>
<wire x1="22.225" y1="2.54" x2="22.86" y2="1.905" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="22.225" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="22.225" y1="-2.54" x2="20.955" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="20.955" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="19.685" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="19.685" y1="-2.54" x2="18.415" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="18.415" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="17.145" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="17.145" y1="-2.54" x2="15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="13.335" y1="-2.54" x2="14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="13.335" y1="-2.54" x2="12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-1.905" x2="12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="10.795" y1="-2.54" x2="12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="10.795" y1="-2.54" x2="10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-1.905" x2="9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="9.525" y1="-2.54" x2="8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="6.985" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="6.985" y1="-2.54" x2="5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="4.445" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="4.445" y1="-2.54" x2="3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="1.905" y1="-2.54" x2="0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="0" y1="-1.905" x2="0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="0" y1="-1.905" x2="-0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="-2.54" x2="-1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="-1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="-3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="-2.54" x2="-4.445" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-4.445" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-5.715" y1="-2.54" x2="-6.985" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-6.985" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-8.255" y1="-2.54" x2="-9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-1.905" x2="-9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="1.905" x2="-22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="1.905" x2="-20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="1.905" x2="-17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="1.905" x2="-15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="1.905" x2="-12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="1.905" x2="-10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="1.905" x2="-7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="1.905" x2="-5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="1.905" x2="-2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="0" y1="1.905" x2="0" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="2.54" y1="1.905" x2="2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="5.08" y1="1.905" x2="5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="7.62" y1="1.905" x2="7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="10.16" y1="1.905" x2="10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="12.7" y1="1.905" x2="12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="15.24" y1="1.905" x2="15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="17.78" y1="1.905" x2="17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="20.32" y1="1.905" x2="20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="22.86" y1="1.905" x2="22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="22.86" y1="1.905" x2="23.495" y2="2.54" width="0.1524" layer="21"/>
<wire x1="24.765" y1="2.54" x2="23.495" y2="2.54" width="0.1524" layer="21"/>
<wire x1="24.765" y1="2.54" x2="25.4" y2="1.905" width="0.1524" layer="21"/>
<wire x1="25.4" y1="-1.905" x2="24.765" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="24.765" y1="-2.54" x2="23.495" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="23.495" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="25.4" y1="1.905" x2="25.4" y2="-1.905" width="0.1524" layer="21"/>
<pad name="1" x="-24.13" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="2" x="-24.13" y="1.27" drill="1.016" shape="octagon"/>
<pad name="3" x="-21.59" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="4" x="-21.59" y="1.27" drill="1.016" shape="octagon"/>
<pad name="5" x="-19.05" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="6" x="-19.05" y="1.27" drill="1.016" shape="octagon"/>
<pad name="7" x="-16.51" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="8" x="-16.51" y="1.27" drill="1.016" shape="octagon"/>
<pad name="9" x="-13.97" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="10" x="-13.97" y="1.27" drill="1.016" shape="octagon"/>
<pad name="11" x="-11.43" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="12" x="-11.43" y="1.27" drill="1.016" shape="octagon"/>
<pad name="13" x="-8.89" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="14" x="-8.89" y="1.27" drill="1.016" shape="octagon"/>
<pad name="15" x="-6.35" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="16" x="-6.35" y="1.27" drill="1.016" shape="octagon"/>
<pad name="17" x="-3.81" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="18" x="-3.81" y="1.27" drill="1.016" shape="octagon"/>
<pad name="19" x="-1.27" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="20" x="-1.27" y="1.27" drill="1.016" shape="octagon"/>
<pad name="21" x="1.27" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="22" x="1.27" y="1.27" drill="1.016" shape="octagon"/>
<pad name="23" x="3.81" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="24" x="3.81" y="1.27" drill="1.016" shape="octagon"/>
<pad name="25" x="6.35" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="26" x="6.35" y="1.27" drill="1.016" shape="octagon"/>
<pad name="27" x="8.89" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="28" x="8.89" y="1.27" drill="1.016" shape="octagon"/>
<pad name="29" x="11.43" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="30" x="11.43" y="1.27" drill="1.016" shape="octagon"/>
<pad name="31" x="13.97" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="32" x="13.97" y="1.27" drill="1.016" shape="octagon"/>
<pad name="33" x="16.51" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="34" x="16.51" y="1.27" drill="1.016" shape="octagon"/>
<pad name="35" x="19.05" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="36" x="19.05" y="1.27" drill="1.016" shape="octagon"/>
<pad name="37" x="21.59" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="38" x="21.59" y="1.27" drill="1.016" shape="octagon"/>
<pad name="39" x="24.13" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="40" x="24.13" y="1.27" drill="1.016" shape="octagon"/>
<text x="-25.4" y="3.175" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-25.4" y="-4.445" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-24.384" y1="-1.524" x2="-23.876" y2="-1.016" layer="51"/>
<rectangle x1="-24.384" y1="1.016" x2="-23.876" y2="1.524" layer="51"/>
<rectangle x1="-21.844" y1="1.016" x2="-21.336" y2="1.524" layer="51"/>
<rectangle x1="-21.844" y1="-1.524" x2="-21.336" y2="-1.016" layer="51"/>
<rectangle x1="-19.304" y1="1.016" x2="-18.796" y2="1.524" layer="51"/>
<rectangle x1="-19.304" y1="-1.524" x2="-18.796" y2="-1.016" layer="51"/>
<rectangle x1="-16.764" y1="1.016" x2="-16.256" y2="1.524" layer="51"/>
<rectangle x1="-14.224" y1="1.016" x2="-13.716" y2="1.524" layer="51"/>
<rectangle x1="-11.684" y1="1.016" x2="-11.176" y2="1.524" layer="51"/>
<rectangle x1="-16.764" y1="-1.524" x2="-16.256" y2="-1.016" layer="51"/>
<rectangle x1="-14.224" y1="-1.524" x2="-13.716" y2="-1.016" layer="51"/>
<rectangle x1="-11.684" y1="-1.524" x2="-11.176" y2="-1.016" layer="51"/>
<rectangle x1="-9.144" y1="1.016" x2="-8.636" y2="1.524" layer="51"/>
<rectangle x1="-9.144" y1="-1.524" x2="-8.636" y2="-1.016" layer="51"/>
<rectangle x1="-6.604" y1="1.016" x2="-6.096" y2="1.524" layer="51"/>
<rectangle x1="-6.604" y1="-1.524" x2="-6.096" y2="-1.016" layer="51"/>
<rectangle x1="-4.064" y1="1.016" x2="-3.556" y2="1.524" layer="51"/>
<rectangle x1="-4.064" y1="-1.524" x2="-3.556" y2="-1.016" layer="51"/>
<rectangle x1="-1.524" y1="1.016" x2="-1.016" y2="1.524" layer="51"/>
<rectangle x1="-1.524" y1="-1.524" x2="-1.016" y2="-1.016" layer="51"/>
<rectangle x1="1.016" y1="1.016" x2="1.524" y2="1.524" layer="51"/>
<rectangle x1="1.016" y1="-1.524" x2="1.524" y2="-1.016" layer="51"/>
<rectangle x1="3.556" y1="1.016" x2="4.064" y2="1.524" layer="51"/>
<rectangle x1="3.556" y1="-1.524" x2="4.064" y2="-1.016" layer="51"/>
<rectangle x1="6.096" y1="1.016" x2="6.604" y2="1.524" layer="51"/>
<rectangle x1="6.096" y1="-1.524" x2="6.604" y2="-1.016" layer="51"/>
<rectangle x1="8.636" y1="1.016" x2="9.144" y2="1.524" layer="51"/>
<rectangle x1="8.636" y1="-1.524" x2="9.144" y2="-1.016" layer="51"/>
<rectangle x1="11.176" y1="1.016" x2="11.684" y2="1.524" layer="51"/>
<rectangle x1="11.176" y1="-1.524" x2="11.684" y2="-1.016" layer="51"/>
<rectangle x1="13.716" y1="1.016" x2="14.224" y2="1.524" layer="51"/>
<rectangle x1="13.716" y1="-1.524" x2="14.224" y2="-1.016" layer="51"/>
<rectangle x1="16.256" y1="1.016" x2="16.764" y2="1.524" layer="51"/>
<rectangle x1="16.256" y1="-1.524" x2="16.764" y2="-1.016" layer="51"/>
<rectangle x1="18.796" y1="1.016" x2="19.304" y2="1.524" layer="51"/>
<rectangle x1="18.796" y1="-1.524" x2="19.304" y2="-1.016" layer="51"/>
<rectangle x1="21.336" y1="1.016" x2="21.844" y2="1.524" layer="51"/>
<rectangle x1="21.336" y1="-1.524" x2="21.844" y2="-1.016" layer="51"/>
<rectangle x1="23.876" y1="1.016" x2="24.384" y2="1.524" layer="51"/>
<rectangle x1="23.876" y1="-1.524" x2="24.384" y2="-1.016" layer="51"/>
</package>
<package name="2X20/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-25.4" y1="-1.905" x2="-22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-1.905" x2="-22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="0.635" x2="-25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="0.635" x2="-25.4" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-24.13" y1="6.985" x2="-24.13" y2="1.27" width="0.762" layer="21"/>
<wire x1="-22.86" y1="-1.905" x2="-20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-1.905" x2="-20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="0.635" x2="-22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-21.59" y1="6.985" x2="-21.59" y2="1.27" width="0.762" layer="21"/>
<wire x1="-20.32" y1="-1.905" x2="-17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="-1.905" x2="-17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="0.635" x2="-20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-19.05" y1="6.985" x2="-19.05" y2="1.27" width="0.762" layer="21"/>
<wire x1="-17.78" y1="-1.905" x2="-15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-1.905" x2="-15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="0.635" x2="-17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-16.51" y1="6.985" x2="-16.51" y2="1.27" width="0.762" layer="21"/>
<wire x1="-15.24" y1="-1.905" x2="-12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-1.905" x2="-12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="0.635" x2="-15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="6.985" x2="-13.97" y2="1.27" width="0.762" layer="21"/>
<wire x1="-12.7" y1="-1.905" x2="-10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-1.905" x2="-10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="0.635" x2="-12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="6.985" x2="-11.43" y2="1.27" width="0.762" layer="21"/>
<wire x1="-10.16" y1="-1.905" x2="-7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="0.635" x2="-10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="6.985" x2="-8.89" y2="1.27" width="0.762" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="0.635" x2="-7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="6.985" x2="-6.35" y2="1.27" width="0.762" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="0.635" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="6.985" x2="-3.81" y2="1.27" width="0.762" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="0" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="0" y1="-1.905" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="0.635" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="6.985" x2="-1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="0" y1="-1.905" x2="2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="0.635" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="6.985" x2="1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="0.635" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="6.985" x2="3.81" y2="1.27" width="0.762" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="7.62" y1="0.635" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="6.35" y1="6.985" x2="6.35" y2="1.27" width="0.762" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-1.905" x2="10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="10.16" y1="0.635" x2="7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="8.89" y1="6.985" x2="8.89" y2="1.27" width="0.762" layer="21"/>
<wire x1="10.16" y1="-1.905" x2="12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-1.905" x2="12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="12.7" y1="0.635" x2="10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="11.43" y1="6.985" x2="11.43" y2="1.27" width="0.762" layer="21"/>
<wire x1="12.7" y1="-1.905" x2="15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="15.24" y1="0.635" x2="12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="13.97" y1="6.985" x2="13.97" y2="1.27" width="0.762" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="17.78" y1="0.635" x2="15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="16.51" y1="6.985" x2="16.51" y2="1.27" width="0.762" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="20.32" y1="0.635" x2="17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="19.05" y1="6.985" x2="19.05" y2="1.27" width="0.762" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="22.86" y1="0.635" x2="20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="21.59" y1="6.985" x2="21.59" y2="1.27" width="0.762" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="25.4" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="25.4" y1="-1.905" x2="25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="25.4" y1="0.635" x2="22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="24.13" y1="6.985" x2="24.13" y2="1.27" width="0.762" layer="21"/>
<pad name="2" x="-24.13" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="4" x="-21.59" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="6" x="-19.05" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="8" x="-16.51" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="10" x="-13.97" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="12" x="-11.43" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="14" x="-8.89" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="16" x="-6.35" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="18" x="-3.81" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="20" x="-1.27" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="22" x="1.27" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="24" x="3.81" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="26" x="6.35" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="28" x="8.89" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="30" x="11.43" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="32" x="13.97" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="34" x="16.51" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="36" x="19.05" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="38" x="21.59" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="1" x="-24.13" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="3" x="-21.59" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="5" x="-19.05" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="7" x="-16.51" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="9" x="-13.97" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="11" x="-11.43" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="13" x="-8.89" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="15" x="-6.35" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="17" x="-3.81" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="19" x="-1.27" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="21" x="1.27" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="23" x="3.81" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="25" x="6.35" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="27" x="8.89" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="29" x="11.43" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="31" x="13.97" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="33" x="16.51" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="35" x="19.05" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="37" x="21.59" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="40" x="24.13" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="39" x="24.13" y="-6.35" drill="1.016" shape="octagon"/>
<text x="-26.035" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="27.305" y="-3.81" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-24.511" y1="0.635" x2="-23.749" y2="1.143" layer="21"/>
<rectangle x1="-21.971" y1="0.635" x2="-21.209" y2="1.143" layer="21"/>
<rectangle x1="-19.431" y1="0.635" x2="-18.669" y2="1.143" layer="21"/>
<rectangle x1="-16.891" y1="0.635" x2="-16.129" y2="1.143" layer="21"/>
<rectangle x1="-14.351" y1="0.635" x2="-13.589" y2="1.143" layer="21"/>
<rectangle x1="-11.811" y1="0.635" x2="-11.049" y2="1.143" layer="21"/>
<rectangle x1="-9.271" y1="0.635" x2="-8.509" y2="1.143" layer="21"/>
<rectangle x1="-6.731" y1="0.635" x2="-5.969" y2="1.143" layer="21"/>
<rectangle x1="-4.191" y1="0.635" x2="-3.429" y2="1.143" layer="21"/>
<rectangle x1="-1.651" y1="0.635" x2="-0.889" y2="1.143" layer="21"/>
<rectangle x1="0.889" y1="0.635" x2="1.651" y2="1.143" layer="21"/>
<rectangle x1="3.429" y1="0.635" x2="4.191" y2="1.143" layer="21"/>
<rectangle x1="5.969" y1="0.635" x2="6.731" y2="1.143" layer="21"/>
<rectangle x1="8.509" y1="0.635" x2="9.271" y2="1.143" layer="21"/>
<rectangle x1="11.049" y1="0.635" x2="11.811" y2="1.143" layer="21"/>
<rectangle x1="13.589" y1="0.635" x2="14.351" y2="1.143" layer="21"/>
<rectangle x1="16.129" y1="0.635" x2="16.891" y2="1.143" layer="21"/>
<rectangle x1="18.669" y1="0.635" x2="19.431" y2="1.143" layer="21"/>
<rectangle x1="21.209" y1="0.635" x2="21.971" y2="1.143" layer="21"/>
<rectangle x1="23.749" y1="0.635" x2="24.511" y2="1.143" layer="21"/>
<rectangle x1="-24.511" y1="-2.921" x2="-23.749" y2="-1.905" layer="21"/>
<rectangle x1="-21.971" y1="-2.921" x2="-21.209" y2="-1.905" layer="21"/>
<rectangle x1="-24.511" y1="-5.461" x2="-23.749" y2="-4.699" layer="21"/>
<rectangle x1="-24.511" y1="-4.699" x2="-23.749" y2="-2.921" layer="51"/>
<rectangle x1="-21.971" y1="-4.699" x2="-21.209" y2="-2.921" layer="51"/>
<rectangle x1="-21.971" y1="-5.461" x2="-21.209" y2="-4.699" layer="21"/>
<rectangle x1="-19.431" y1="-2.921" x2="-18.669" y2="-1.905" layer="21"/>
<rectangle x1="-16.891" y1="-2.921" x2="-16.129" y2="-1.905" layer="21"/>
<rectangle x1="-19.431" y1="-5.461" x2="-18.669" y2="-4.699" layer="21"/>
<rectangle x1="-19.431" y1="-4.699" x2="-18.669" y2="-2.921" layer="51"/>
<rectangle x1="-16.891" y1="-4.699" x2="-16.129" y2="-2.921" layer="51"/>
<rectangle x1="-16.891" y1="-5.461" x2="-16.129" y2="-4.699" layer="21"/>
<rectangle x1="-14.351" y1="-2.921" x2="-13.589" y2="-1.905" layer="21"/>
<rectangle x1="-14.351" y1="-5.461" x2="-13.589" y2="-4.699" layer="21"/>
<rectangle x1="-14.351" y1="-4.699" x2="-13.589" y2="-2.921" layer="51"/>
<rectangle x1="-11.811" y1="-2.921" x2="-11.049" y2="-1.905" layer="21"/>
<rectangle x1="-9.271" y1="-2.921" x2="-8.509" y2="-1.905" layer="21"/>
<rectangle x1="-11.811" y1="-5.461" x2="-11.049" y2="-4.699" layer="21"/>
<rectangle x1="-11.811" y1="-4.699" x2="-11.049" y2="-2.921" layer="51"/>
<rectangle x1="-9.271" y1="-4.699" x2="-8.509" y2="-2.921" layer="51"/>
<rectangle x1="-9.271" y1="-5.461" x2="-8.509" y2="-4.699" layer="21"/>
<rectangle x1="-6.731" y1="-2.921" x2="-5.969" y2="-1.905" layer="21"/>
<rectangle x1="-4.191" y1="-2.921" x2="-3.429" y2="-1.905" layer="21"/>
<rectangle x1="-6.731" y1="-5.461" x2="-5.969" y2="-4.699" layer="21"/>
<rectangle x1="-6.731" y1="-4.699" x2="-5.969" y2="-2.921" layer="51"/>
<rectangle x1="-4.191" y1="-4.699" x2="-3.429" y2="-2.921" layer="51"/>
<rectangle x1="-4.191" y1="-5.461" x2="-3.429" y2="-4.699" layer="21"/>
<rectangle x1="-1.651" y1="-2.921" x2="-0.889" y2="-1.905" layer="21"/>
<rectangle x1="-1.651" y1="-5.461" x2="-0.889" y2="-4.699" layer="21"/>
<rectangle x1="-1.651" y1="-4.699" x2="-0.889" y2="-2.921" layer="51"/>
<rectangle x1="0.889" y1="-2.921" x2="1.651" y2="-1.905" layer="21"/>
<rectangle x1="3.429" y1="-2.921" x2="4.191" y2="-1.905" layer="21"/>
<rectangle x1="0.889" y1="-5.461" x2="1.651" y2="-4.699" layer="21"/>
<rectangle x1="0.889" y1="-4.699" x2="1.651" y2="-2.921" layer="51"/>
<rectangle x1="3.429" y1="-4.699" x2="4.191" y2="-2.921" layer="51"/>
<rectangle x1="3.429" y1="-5.461" x2="4.191" y2="-4.699" layer="21"/>
<rectangle x1="5.969" y1="-2.921" x2="6.731" y2="-1.905" layer="21"/>
<rectangle x1="8.509" y1="-2.921" x2="9.271" y2="-1.905" layer="21"/>
<rectangle x1="5.969" y1="-5.461" x2="6.731" y2="-4.699" layer="21"/>
<rectangle x1="5.969" y1="-4.699" x2="6.731" y2="-2.921" layer="51"/>
<rectangle x1="8.509" y1="-4.699" x2="9.271" y2="-2.921" layer="51"/>
<rectangle x1="8.509" y1="-5.461" x2="9.271" y2="-4.699" layer="21"/>
<rectangle x1="11.049" y1="-2.921" x2="11.811" y2="-1.905" layer="21"/>
<rectangle x1="11.049" y1="-5.461" x2="11.811" y2="-4.699" layer="21"/>
<rectangle x1="11.049" y1="-4.699" x2="11.811" y2="-2.921" layer="51"/>
<rectangle x1="13.589" y1="-2.921" x2="14.351" y2="-1.905" layer="21"/>
<rectangle x1="16.129" y1="-2.921" x2="16.891" y2="-1.905" layer="21"/>
<rectangle x1="13.589" y1="-5.461" x2="14.351" y2="-4.699" layer="21"/>
<rectangle x1="13.589" y1="-4.699" x2="14.351" y2="-2.921" layer="51"/>
<rectangle x1="16.129" y1="-4.699" x2="16.891" y2="-2.921" layer="51"/>
<rectangle x1="16.129" y1="-5.461" x2="16.891" y2="-4.699" layer="21"/>
<rectangle x1="18.669" y1="-2.921" x2="19.431" y2="-1.905" layer="21"/>
<rectangle x1="21.209" y1="-2.921" x2="21.971" y2="-1.905" layer="21"/>
<rectangle x1="18.669" y1="-5.461" x2="19.431" y2="-4.699" layer="21"/>
<rectangle x1="18.669" y1="-4.699" x2="19.431" y2="-2.921" layer="51"/>
<rectangle x1="21.209" y1="-4.699" x2="21.971" y2="-2.921" layer="51"/>
<rectangle x1="21.209" y1="-5.461" x2="21.971" y2="-4.699" layer="21"/>
<rectangle x1="23.749" y1="-2.921" x2="24.511" y2="-1.905" layer="21"/>
<rectangle x1="23.749" y1="-5.461" x2="24.511" y2="-4.699" layer="21"/>
<rectangle x1="23.749" y1="-4.699" x2="24.511" y2="-2.921" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="PINH2X20">
<wire x1="-6.35" y1="-27.94" x2="8.89" y2="-27.94" width="0.4064" layer="94"/>
<wire x1="8.89" y1="-27.94" x2="8.89" y2="25.4" width="0.4064" layer="94"/>
<wire x1="8.89" y1="25.4" x2="-6.35" y2="25.4" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="25.4" x2="-6.35" y2="-27.94" width="0.4064" layer="94"/>
<text x="-6.35" y="26.035" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-30.48" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="22.86" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="5.08" y="22.86" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="3" x="-2.54" y="20.32" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="4" x="5.08" y="20.32" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="5" x="-2.54" y="17.78" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="6" x="5.08" y="17.78" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="7" x="-2.54" y="15.24" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="8" x="5.08" y="15.24" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="9" x="-2.54" y="12.7" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="10" x="5.08" y="12.7" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="11" x="-2.54" y="10.16" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="12" x="5.08" y="10.16" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="13" x="-2.54" y="7.62" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="14" x="5.08" y="7.62" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="15" x="-2.54" y="5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="16" x="5.08" y="5.08" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="17" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="18" x="5.08" y="2.54" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="19" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="20" x="5.08" y="0" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="21" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="22" x="5.08" y="-2.54" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="23" x="-2.54" y="-5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="24" x="5.08" y="-5.08" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="25" x="-2.54" y="-7.62" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="26" x="5.08" y="-7.62" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="27" x="-2.54" y="-10.16" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="28" x="5.08" y="-10.16" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="29" x="-2.54" y="-12.7" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="30" x="5.08" y="-12.7" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="31" x="-2.54" y="-15.24" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="32" x="5.08" y="-15.24" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="33" x="-2.54" y="-17.78" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="34" x="5.08" y="-17.78" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="35" x="-2.54" y="-20.32" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="36" x="5.08" y="-20.32" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="37" x="-2.54" y="-22.86" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="38" x="5.08" y="-22.86" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="39" x="-2.54" y="-25.4" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="40" x="5.08" y="-25.4" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="PINHD-2X20" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINH2X20" x="0" y="0"/>
</gates>
<devices>
<device name="" package="2X20">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="10" pad="10"/>
<connect gate="A" pin="11" pad="11"/>
<connect gate="A" pin="12" pad="12"/>
<connect gate="A" pin="13" pad="13"/>
<connect gate="A" pin="14" pad="14"/>
<connect gate="A" pin="15" pad="15"/>
<connect gate="A" pin="16" pad="16"/>
<connect gate="A" pin="17" pad="17"/>
<connect gate="A" pin="18" pad="18"/>
<connect gate="A" pin="19" pad="19"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="20" pad="20"/>
<connect gate="A" pin="21" pad="21"/>
<connect gate="A" pin="22" pad="22"/>
<connect gate="A" pin="23" pad="23"/>
<connect gate="A" pin="24" pad="24"/>
<connect gate="A" pin="25" pad="25"/>
<connect gate="A" pin="26" pad="26"/>
<connect gate="A" pin="27" pad="27"/>
<connect gate="A" pin="28" pad="28"/>
<connect gate="A" pin="29" pad="29"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="30" pad="30"/>
<connect gate="A" pin="31" pad="31"/>
<connect gate="A" pin="32" pad="32"/>
<connect gate="A" pin="33" pad="33"/>
<connect gate="A" pin="34" pad="34"/>
<connect gate="A" pin="35" pad="35"/>
<connect gate="A" pin="36" pad="36"/>
<connect gate="A" pin="37" pad="37"/>
<connect gate="A" pin="38" pad="38"/>
<connect gate="A" pin="39" pad="39"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="40" pad="40"/>
<connect gate="A" pin="5" pad="5"/>
<connect gate="A" pin="6" pad="6"/>
<connect gate="A" pin="7" pad="7"/>
<connect gate="A" pin="8" pad="8"/>
<connect gate="A" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="2X20/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="10" pad="10"/>
<connect gate="A" pin="11" pad="11"/>
<connect gate="A" pin="12" pad="12"/>
<connect gate="A" pin="13" pad="13"/>
<connect gate="A" pin="14" pad="14"/>
<connect gate="A" pin="15" pad="15"/>
<connect gate="A" pin="16" pad="16"/>
<connect gate="A" pin="17" pad="17"/>
<connect gate="A" pin="18" pad="18"/>
<connect gate="A" pin="19" pad="19"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="20" pad="20"/>
<connect gate="A" pin="21" pad="21"/>
<connect gate="A" pin="22" pad="22"/>
<connect gate="A" pin="23" pad="23"/>
<connect gate="A" pin="24" pad="24"/>
<connect gate="A" pin="25" pad="25"/>
<connect gate="A" pin="26" pad="26"/>
<connect gate="A" pin="27" pad="27"/>
<connect gate="A" pin="28" pad="28"/>
<connect gate="A" pin="29" pad="29"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="30" pad="30"/>
<connect gate="A" pin="31" pad="31"/>
<connect gate="A" pin="32" pad="32"/>
<connect gate="A" pin="33" pad="33"/>
<connect gate="A" pin="34" pad="34"/>
<connect gate="A" pin="35" pad="35"/>
<connect gate="A" pin="36" pad="36"/>
<connect gate="A" pin="37" pad="37"/>
<connect gate="A" pin="38" pad="38"/>
<connect gate="A" pin="39" pad="39"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="40" pad="40"/>
<connect gate="A" pin="5" pad="5"/>
<connect gate="A" pin="6" pad="6"/>
<connect gate="A" pin="7" pad="7"/>
<connect gate="A" pin="8" pad="8"/>
<connect gate="A" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="con-lsta">
<description>&lt;b&gt;Female Headers etc.&lt;/b&gt;&lt;p&gt;
Naming:&lt;p&gt;
FE = female&lt;p&gt;
# contacts - # rows&lt;p&gt;
W = angled&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="FE20-2W">
<description>&lt;b&gt;FEMALE HEADER&lt;/b&gt;</description>
<wire x1="-25.4" y1="-2.159" x2="-22.86" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-2.159" x2="-22.86" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-2.159" x2="-20.32" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-2.159" x2="-20.32" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-10.16" x2="-22.86" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="-2.159" x2="-25.4" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-10.16" x2="-25.4" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-2.159" x2="-17.78" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="-10.16" x2="-20.32" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-2.159" x2="-15.24" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-10.16" x2="-15.24" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="-2.159" x2="-17.78" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-2.159" x2="-17.78" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-10.16" x2="-17.78" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-2.159" x2="-12.7" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-2.159" x2="-10.16" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-2.159" x2="-10.16" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-2.159" x2="-7.62" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-2.159" x2="-7.62" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-10.16" x2="-10.16" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-2.159" x2="-12.7" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-10.16" x2="-12.7" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-2.159" x2="-5.08" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-10.16" x2="-7.62" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-2.159" x2="-2.54" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-2.159" x2="0" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="0" y1="-2.159" x2="0" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="0" y1="-10.16" x2="-2.54" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-2.159" x2="-5.08" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-2.159" x2="-5.08" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-10.16" x2="-5.08" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="0" y1="-2.159" x2="2.54" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-2.159" x2="2.54" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-2.159" x2="5.08" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-2.159" x2="5.08" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-10.16" x2="2.54" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-10.16" x2="0" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-2.159" x2="7.62" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-10.16" x2="5.08" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-2.159" x2="10.16" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-10.16" x2="10.16" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-2.159" x2="7.62" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-2.159" x2="7.62" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-10.16" x2="7.62" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-2.159" x2="12.7" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-2.159" x2="15.24" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-2.159" x2="15.24" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-2.159" x2="17.78" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-2.159" x2="17.78" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-10.16" x2="15.24" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-2.159" x2="12.7" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-10.16" x2="12.7" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-2.159" x2="20.32" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-10.16" x2="17.78" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-2.159" x2="22.86" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-2.159" x2="25.4" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="25.4" y1="-2.159" x2="25.4" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="25.4" y1="-10.16" x2="22.86" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-2.159" x2="20.32" y2="-10.16" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-2.159" x2="20.32" y2="-2.159" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-10.16" x2="20.32" y2="-10.16" width="0.1524" layer="21"/>
<pad name="40" x="24.13" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="38" x="21.59" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="36" x="19.05" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="34" x="16.51" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="32" x="13.97" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="30" x="11.43" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="28" x="8.89" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="26" x="6.35" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="24" x="3.81" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="22" x="1.27" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="20" x="-1.27" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="18" x="-3.81" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="16" x="-6.35" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="14" x="-8.89" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="12" x="-11.43" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="10" x="-13.97" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="8" x="-16.51" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="6" x="-19.05" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="4" x="-21.59" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="2" x="-24.13" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="1" x="-24.13" y="1.27" drill="1.016" shape="octagon"/>
<pad name="3" x="-21.59" y="1.27" drill="1.016" shape="octagon"/>
<pad name="5" x="-19.05" y="1.27" drill="1.016" shape="octagon"/>
<pad name="7" x="-16.51" y="1.27" drill="1.016" shape="octagon"/>
<pad name="9" x="-13.97" y="1.27" drill="1.016" shape="octagon"/>
<pad name="11" x="-11.43" y="1.27" drill="1.016" shape="octagon"/>
<pad name="13" x="-8.89" y="1.27" drill="1.016" shape="octagon"/>
<pad name="15" x="-6.35" y="1.27" drill="1.016" shape="octagon"/>
<pad name="17" x="-3.81" y="1.27" drill="1.016" shape="octagon"/>
<pad name="19" x="-1.27" y="1.27" drill="1.016" shape="octagon"/>
<pad name="21" x="1.27" y="1.27" drill="1.016" shape="octagon"/>
<pad name="23" x="3.81" y="1.27" drill="1.016" shape="octagon"/>
<pad name="25" x="6.35" y="1.27" drill="1.016" shape="octagon"/>
<pad name="27" x="8.89" y="1.27" drill="1.016" shape="octagon"/>
<pad name="29" x="11.43" y="1.27" drill="1.016" shape="octagon"/>
<pad name="31" x="13.97" y="1.27" drill="1.016" shape="octagon"/>
<pad name="33" x="16.51" y="1.27" drill="1.016" shape="octagon"/>
<pad name="35" x="19.05" y="1.27" drill="1.016" shape="octagon"/>
<pad name="37" x="21.59" y="1.27" drill="1.016" shape="octagon"/>
<pad name="39" x="24.13" y="1.27" drill="1.016" shape="octagon"/>
<text x="-25.4" y="2.54" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="24.765" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">40</text>
<text x="22.225" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">38</text>
<text x="19.685" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">36</text>
<text x="17.145" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">34</text>
<text x="14.605" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">32</text>
<text x="12.065" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">30</text>
<text x="9.525" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">28</text>
<text x="6.985" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">26</text>
<text x="4.445" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">24</text>
<text x="1.905" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">22</text>
<text x="-0.635" y="-9.398" size="1.27" layer="21" ratio="10" rot="R90">20</text>
<text x="-3.175" y="-9.525" size="1.27" layer="21" ratio="10" rot="R90">18</text>
<text x="-5.715" y="-9.525" size="1.27" layer="21" ratio="10" rot="R90">16</text>
<text x="-8.255" y="-9.525" size="1.27" layer="21" ratio="10" rot="R90">14</text>
<text x="-10.795" y="-9.525" size="1.27" layer="21" ratio="10" rot="R90">12</text>
<text x="-13.335" y="-9.525" size="1.27" layer="21" ratio="10" rot="R90">10</text>
<text x="-15.875" y="-9.271" size="1.27" layer="21" ratio="10" rot="R90">8</text>
<text x="-18.415" y="-9.271" size="1.27" layer="21" ratio="10" rot="R90">6</text>
<text x="-20.955" y="-9.271" size="1.27" layer="21" ratio="10" rot="R90">4</text>
<text x="-23.495" y="-9.271" size="1.27" layer="21" ratio="10" rot="R90">2</text>
<text x="-15.24" y="2.54" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<rectangle x1="23.7998" y1="-0.4064" x2="24.4602" y2="0.4064" layer="21"/>
<rectangle x1="23.7998" y1="-2.1336" x2="24.4602" y2="-0.4064" layer="51"/>
<rectangle x1="23.7998" y1="0.4064" x2="24.4602" y2="1.5748" layer="51"/>
<rectangle x1="21.2598" y1="-0.4064" x2="21.9202" y2="0.4064" layer="21"/>
<rectangle x1="21.2598" y1="-2.1336" x2="21.9202" y2="-0.4064" layer="51"/>
<rectangle x1="21.2598" y1="0.4064" x2="21.9202" y2="1.5748" layer="51"/>
<rectangle x1="18.7198" y1="-0.4064" x2="19.3802" y2="0.4064" layer="21"/>
<rectangle x1="18.7198" y1="-2.1336" x2="19.3802" y2="-0.4064" layer="51"/>
<rectangle x1="18.7198" y1="0.4064" x2="19.3802" y2="1.5748" layer="51"/>
<rectangle x1="16.1798" y1="-0.4064" x2="16.8402" y2="0.4064" layer="21"/>
<rectangle x1="16.1798" y1="-2.1336" x2="16.8402" y2="-0.4064" layer="51"/>
<rectangle x1="16.1798" y1="0.4064" x2="16.8402" y2="1.5748" layer="51"/>
<rectangle x1="13.6398" y1="-0.4064" x2="14.3002" y2="0.4064" layer="21"/>
<rectangle x1="11.0998" y1="-0.4064" x2="11.7602" y2="0.4064" layer="21"/>
<rectangle x1="13.6398" y1="-2.1336" x2="14.3002" y2="-0.4064" layer="51"/>
<rectangle x1="11.0998" y1="-2.1336" x2="11.7602" y2="-0.4064" layer="51"/>
<rectangle x1="13.6398" y1="0.4064" x2="14.3002" y2="1.5748" layer="51"/>
<rectangle x1="11.0998" y1="0.4064" x2="11.7602" y2="1.5748" layer="51"/>
<rectangle x1="8.5598" y1="-0.4064" x2="9.2202" y2="0.4064" layer="21"/>
<rectangle x1="6.0198" y1="-0.4064" x2="6.6802" y2="0.4064" layer="21"/>
<rectangle x1="8.5598" y1="-2.1336" x2="9.2202" y2="-0.4064" layer="51"/>
<rectangle x1="8.5598" y1="0.4064" x2="9.2202" y2="1.5748" layer="51"/>
<rectangle x1="6.0198" y1="-2.1336" x2="6.6802" y2="-0.4064" layer="51"/>
<rectangle x1="6.0198" y1="0.4064" x2="6.6802" y2="1.5748" layer="51"/>
<rectangle x1="3.4798" y1="-0.4064" x2="4.1402" y2="0.4064" layer="21"/>
<rectangle x1="0.9398" y1="-0.4064" x2="1.6002" y2="0.4064" layer="21"/>
<rectangle x1="3.4798" y1="-2.1336" x2="4.1402" y2="-0.4064" layer="51"/>
<rectangle x1="0.9398" y1="-2.1336" x2="1.6002" y2="-0.4064" layer="51"/>
<rectangle x1="3.4798" y1="0.4064" x2="4.1402" y2="1.5748" layer="51"/>
<rectangle x1="0.9398" y1="0.4064" x2="1.6002" y2="1.5748" layer="51"/>
<rectangle x1="-1.6002" y1="-0.4064" x2="-0.9398" y2="0.4064" layer="21"/>
<rectangle x1="-4.1402" y1="-0.4064" x2="-3.4798" y2="0.4064" layer="21"/>
<rectangle x1="-6.6802" y1="-0.4064" x2="-6.0198" y2="0.4064" layer="21"/>
<rectangle x1="-1.6002" y1="-2.1336" x2="-0.9398" y2="-0.4064" layer="51"/>
<rectangle x1="-4.1402" y1="-2.1336" x2="-3.4798" y2="-0.4064" layer="51"/>
<rectangle x1="-6.6802" y1="-2.1336" x2="-6.0198" y2="-0.4064" layer="51"/>
<rectangle x1="-1.6002" y1="0.4064" x2="-0.9398" y2="1.5748" layer="51"/>
<rectangle x1="-4.1402" y1="0.4064" x2="-3.4798" y2="1.5748" layer="51"/>
<rectangle x1="-6.6802" y1="0.4064" x2="-6.0198" y2="1.5748" layer="51"/>
<rectangle x1="-9.2202" y1="-0.4064" x2="-8.5598" y2="0.4064" layer="21"/>
<rectangle x1="-11.7602" y1="-0.4064" x2="-11.0998" y2="0.4064" layer="21"/>
<rectangle x1="-9.2202" y1="0.4064" x2="-8.5598" y2="1.5748" layer="51"/>
<rectangle x1="-11.7602" y1="0.4064" x2="-11.0998" y2="1.5748" layer="51"/>
<rectangle x1="-9.2202" y1="-2.1336" x2="-8.5598" y2="-0.4064" layer="51"/>
<rectangle x1="-11.7602" y1="-2.1336" x2="-11.0998" y2="-0.4064" layer="51"/>
<rectangle x1="-14.3002" y1="-0.4064" x2="-13.6398" y2="0.4064" layer="21"/>
<rectangle x1="-16.8402" y1="-0.4064" x2="-16.1798" y2="0.4064" layer="21"/>
<rectangle x1="-14.3002" y1="-2.1336" x2="-13.6398" y2="-0.4064" layer="51"/>
<rectangle x1="-16.8402" y1="-2.1336" x2="-16.1798" y2="-0.4064" layer="51"/>
<rectangle x1="-14.3002" y1="0.4064" x2="-13.6398" y2="1.5748" layer="51"/>
<rectangle x1="-16.8402" y1="0.4064" x2="-16.1798" y2="1.5748" layer="51"/>
<rectangle x1="-19.3802" y1="-0.4064" x2="-18.7198" y2="0.4064" layer="21"/>
<rectangle x1="-21.9202" y1="-0.4064" x2="-21.2598" y2="0.4064" layer="21"/>
<rectangle x1="-24.4602" y1="-0.4064" x2="-23.7998" y2="0.4064" layer="21"/>
<rectangle x1="-19.3802" y1="-2.1336" x2="-18.7198" y2="-0.4064" layer="51"/>
<rectangle x1="-21.9202" y1="-2.1336" x2="-21.2598" y2="-0.4064" layer="51"/>
<rectangle x1="-24.4602" y1="-2.1336" x2="-23.7998" y2="-0.4064" layer="51"/>
<rectangle x1="-19.3802" y1="0.4064" x2="-18.7198" y2="1.5748" layer="51"/>
<rectangle x1="-21.9202" y1="0.4064" x2="-21.2598" y2="1.5748" layer="51"/>
<rectangle x1="-24.4602" y1="0.4064" x2="-23.7998" y2="1.5748" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="FE20-2">
<wire x1="3.81" y1="-27.94" x2="-3.81" y2="-27.94" width="0.4064" layer="94"/>
<wire x1="-1.905" y1="-20.955" x2="-1.905" y2="-19.685" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-23.495" x2="-1.905" y2="-22.225" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-26.035" x2="-1.905" y2="-24.765" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-19.685" x2="1.905" y2="-20.955" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-22.225" x2="1.905" y2="-23.495" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-24.765" x2="1.905" y2="-26.035" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-15.875" x2="-1.905" y2="-14.605" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-18.415" x2="-1.905" y2="-17.145" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-14.605" x2="1.905" y2="-15.875" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-17.145" x2="1.905" y2="-18.415" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-8.255" x2="-1.905" y2="-6.985" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-10.795" x2="-1.905" y2="-9.525" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-13.335" x2="-1.905" y2="-12.065" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-6.985" x2="1.905" y2="-8.255" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-9.525" x2="1.905" y2="-10.795" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-12.065" x2="1.905" y2="-13.335" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-3.175" x2="-1.905" y2="-1.905" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-5.715" x2="-1.905" y2="-4.445" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-1.905" x2="1.905" y2="-3.175" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="-4.445" x2="1.905" y2="-5.715" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="4.445" x2="-1.905" y2="5.715" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="1.905" x2="-1.905" y2="3.175" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="-0.635" x2="-1.905" y2="0.635" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="5.715" x2="1.905" y2="4.445" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="3.175" x2="1.905" y2="1.905" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="0.635" x2="1.905" y2="-0.635" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="9.525" x2="-1.905" y2="10.795" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="6.985" x2="-1.905" y2="8.255" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="10.795" x2="1.905" y2="9.525" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="8.255" x2="1.905" y2="6.985" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="14.605" x2="-1.905" y2="15.875" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="12.065" x2="-1.905" y2="13.335" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="15.875" x2="1.905" y2="14.605" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="13.335" x2="1.905" y2="12.065" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="22.225" x2="-1.905" y2="23.495" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="19.685" x2="-1.905" y2="20.955" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-1.905" y1="17.145" x2="-1.905" y2="18.415" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="23.495" x2="1.905" y2="22.225" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="20.955" x2="1.905" y2="19.685" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="1.905" y1="18.415" x2="1.905" y2="17.145" width="0.254" layer="94" curve="-180" cap="flat"/>
<wire x1="-3.81" y1="25.4" x2="-3.81" y2="-27.94" width="0.4064" layer="94"/>
<wire x1="3.81" y1="-27.94" x2="3.81" y2="25.4" width="0.4064" layer="94"/>
<wire x1="-3.81" y1="25.4" x2="3.81" y2="25.4" width="0.4064" layer="94"/>
<text x="-3.81" y="-30.48" size="1.778" layer="96">&gt;VALUE</text>
<text x="-3.81" y="26.162" size="1.778" layer="95">&gt;NAME</text>
<pin name="1" x="-7.62" y="-25.4" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="3" x="-7.62" y="-22.86" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="5" x="-7.62" y="-20.32" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="2" x="7.62" y="-25.4" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="4" x="7.62" y="-22.86" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="6" x="7.62" y="-20.32" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="7" x="-7.62" y="-17.78" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="9" x="-7.62" y="-15.24" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="8" x="7.62" y="-17.78" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="10" x="7.62" y="-15.24" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="11" x="-7.62" y="-12.7" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="13" x="-7.62" y="-10.16" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="15" x="-7.62" y="-7.62" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="12" x="7.62" y="-12.7" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="14" x="7.62" y="-10.16" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="16" x="7.62" y="-7.62" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="17" x="-7.62" y="-5.08" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="19" x="-7.62" y="-2.54" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="18" x="7.62" y="-5.08" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="20" x="7.62" y="-2.54" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="21" x="-7.62" y="0" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="23" x="-7.62" y="2.54" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="25" x="-7.62" y="5.08" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="22" x="7.62" y="0" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="24" x="7.62" y="2.54" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="26" x="7.62" y="5.08" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="27" x="-7.62" y="7.62" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="29" x="-7.62" y="10.16" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="28" x="7.62" y="7.62" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="30" x="7.62" y="10.16" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="31" x="-7.62" y="12.7" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="33" x="-7.62" y="15.24" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="32" x="7.62" y="12.7" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="34" x="7.62" y="15.24" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="35" x="-7.62" y="17.78" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="37" x="-7.62" y="20.32" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="39" x="-7.62" y="22.86" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="36" x="7.62" y="17.78" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="38" x="7.62" y="20.32" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="40" x="7.62" y="22.86" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="FE20-2W" prefix="SV" uservalue="yes">
<description>&lt;b&gt;FEMALE HEADER&lt;/b&gt;</description>
<gates>
<gate name="1" symbol="FE20-2" x="0" y="0"/>
</gates>
<devices>
<device name="" package="FE20-2W">
<connects>
<connect gate="1" pin="1" pad="1"/>
<connect gate="1" pin="10" pad="10"/>
<connect gate="1" pin="11" pad="11"/>
<connect gate="1" pin="12" pad="12"/>
<connect gate="1" pin="13" pad="13"/>
<connect gate="1" pin="14" pad="14"/>
<connect gate="1" pin="15" pad="15"/>
<connect gate="1" pin="16" pad="16"/>
<connect gate="1" pin="17" pad="17"/>
<connect gate="1" pin="18" pad="18"/>
<connect gate="1" pin="19" pad="19"/>
<connect gate="1" pin="2" pad="2"/>
<connect gate="1" pin="20" pad="20"/>
<connect gate="1" pin="21" pad="21"/>
<connect gate="1" pin="22" pad="22"/>
<connect gate="1" pin="23" pad="23"/>
<connect gate="1" pin="24" pad="24"/>
<connect gate="1" pin="25" pad="25"/>
<connect gate="1" pin="26" pad="26"/>
<connect gate="1" pin="27" pad="27"/>
<connect gate="1" pin="28" pad="28"/>
<connect gate="1" pin="29" pad="29"/>
<connect gate="1" pin="3" pad="3"/>
<connect gate="1" pin="30" pad="30"/>
<connect gate="1" pin="31" pad="31"/>
<connect gate="1" pin="32" pad="32"/>
<connect gate="1" pin="33" pad="33"/>
<connect gate="1" pin="34" pad="34"/>
<connect gate="1" pin="35" pad="35"/>
<connect gate="1" pin="36" pad="36"/>
<connect gate="1" pin="37" pad="37"/>
<connect gate="1" pin="38" pad="38"/>
<connect gate="1" pin="39" pad="39"/>
<connect gate="1" pin="4" pad="4"/>
<connect gate="1" pin="40" pad="40"/>
<connect gate="1" pin="5" pad="5"/>
<connect gate="1" pin="6" pad="6"/>
<connect gate="1" pin="7" pad="7"/>
<connect gate="1" pin="8" pad="8"/>
<connect gate="1" pin="9" pad="9"/>
</connects>
<technologies>
<technology name="">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="JP1" library="pinhead" deviceset="PINHD-2X20" device="/90"/>
<part name="SV1" library="con-lsta" deviceset="FE20-2W" device=""/>
</parts>
<sheets>
<sheet>
<plain>
<text x="48.26" y="99.06" size="5.08" layer="91">Card Bus In</text>
<text x="147.32" y="99.06" size="5.08" layer="91">Card Bus Out</text>
<text x="66.04" y="127" size="7.62" layer="91">Card Extender Board</text>
</plain>
<instances>
<instance part="JP1" gate="A" x="63.5" y="63.5"/>
<instance part="SV1" gate="1" x="167.64" y="60.96" rot="MR180"/>
</instances>
<busses>
</busses>
<nets>
<net name="A15" class="0">
<segment>
<pinref part="JP1" gate="A" pin="11"/>
<wire x1="60.96" y1="73.66" x2="38.1" y2="73.66" width="0.1524" layer="91"/>
<label x="38.1" y="73.66" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="11"/>
<wire x1="142.24" y1="73.66" x2="160.02" y2="73.66" width="0.1524" layer="91"/>
<label x="142.24" y="73.66" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A14" class="0">
<segment>
<pinref part="JP1" gate="A" pin="13"/>
<wire x1="60.96" y1="71.12" x2="38.1" y2="71.12" width="0.1524" layer="91"/>
<label x="38.1" y="71.12" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="13"/>
<wire x1="142.24" y1="71.12" x2="160.02" y2="71.12" width="0.1524" layer="91"/>
<label x="142.24" y="71.12" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A13" class="0">
<segment>
<pinref part="JP1" gate="A" pin="15"/>
<wire x1="60.96" y1="68.58" x2="38.1" y2="68.58" width="0.1524" layer="91"/>
<label x="38.1" y="68.58" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="15"/>
<wire x1="142.24" y1="68.58" x2="160.02" y2="68.58" width="0.1524" layer="91"/>
<label x="142.24" y="68.58" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A12" class="0">
<segment>
<pinref part="JP1" gate="A" pin="17"/>
<wire x1="60.96" y1="66.04" x2="38.1" y2="66.04" width="0.1524" layer="91"/>
<label x="38.1" y="66.04" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="17"/>
<wire x1="142.24" y1="66.04" x2="160.02" y2="66.04" width="0.1524" layer="91"/>
<label x="142.24" y="66.04" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A11" class="0">
<segment>
<pinref part="JP1" gate="A" pin="19"/>
<wire x1="60.96" y1="63.5" x2="38.1" y2="63.5" width="0.1524" layer="91"/>
<label x="38.1" y="63.5" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="19"/>
<wire x1="142.24" y1="63.5" x2="160.02" y2="63.5" width="0.1524" layer="91"/>
<label x="142.24" y="63.5" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A10" class="0">
<segment>
<pinref part="JP1" gate="A" pin="21"/>
<wire x1="60.96" y1="60.96" x2="38.1" y2="60.96" width="0.1524" layer="91"/>
<label x="38.1" y="60.96" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="21"/>
<wire x1="142.24" y1="60.96" x2="160.02" y2="60.96" width="0.1524" layer="91"/>
<label x="142.24" y="60.96" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A9" class="0">
<segment>
<pinref part="JP1" gate="A" pin="23"/>
<wire x1="38.1" y1="58.42" x2="60.96" y2="58.42" width="0.1524" layer="91"/>
<label x="38.1" y="58.42" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="23"/>
<wire x1="142.24" y1="58.42" x2="160.02" y2="58.42" width="0.1524" layer="91"/>
<label x="142.24" y="58.42" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A8" class="0">
<segment>
<pinref part="JP1" gate="A" pin="25"/>
<wire x1="38.1" y1="55.88" x2="60.96" y2="55.88" width="0.1524" layer="91"/>
<label x="38.1" y="55.88" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="25"/>
<wire x1="142.24" y1="55.88" x2="160.02" y2="55.88" width="0.1524" layer="91"/>
<label x="142.24" y="55.88" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A0" class="0">
<segment>
<pinref part="JP1" gate="A" pin="40"/>
<wire x1="91.44" y1="38.1" x2="68.58" y2="38.1" width="0.1524" layer="91"/>
<label x="91.44" y="38.1" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="40"/>
<wire x1="195.58" y1="38.1" x2="175.26" y2="38.1" width="0.1524" layer="91"/>
<label x="195.58" y="38.1" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="A1" class="0">
<segment>
<pinref part="JP1" gate="A" pin="39"/>
<wire x1="38.1" y1="38.1" x2="60.96" y2="38.1" width="0.1524" layer="91"/>
<label x="38.1" y="38.1" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="39"/>
<wire x1="142.24" y1="38.1" x2="160.02" y2="38.1" width="0.1524" layer="91"/>
<label x="142.24" y="38.1" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A2" class="0">
<segment>
<pinref part="JP1" gate="A" pin="37"/>
<wire x1="38.1" y1="40.64" x2="60.96" y2="40.64" width="0.1524" layer="91"/>
<label x="38.1" y="40.64" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="37"/>
<wire x1="142.24" y1="40.64" x2="160.02" y2="40.64" width="0.1524" layer="91"/>
<label x="142.24" y="40.64" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A3" class="0">
<segment>
<pinref part="JP1" gate="A" pin="35"/>
<wire x1="38.1" y1="43.18" x2="60.96" y2="43.18" width="0.1524" layer="91"/>
<label x="38.1" y="43.18" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="35"/>
<wire x1="142.24" y1="43.18" x2="160.02" y2="43.18" width="0.1524" layer="91"/>
<label x="142.24" y="43.18" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A4" class="0">
<segment>
<pinref part="JP1" gate="A" pin="33"/>
<wire x1="38.1" y1="45.72" x2="60.96" y2="45.72" width="0.1524" layer="91"/>
<label x="38.1" y="45.72" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="33"/>
<wire x1="142.24" y1="45.72" x2="160.02" y2="45.72" width="0.1524" layer="91"/>
<label x="142.24" y="45.72" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A5" class="0">
<segment>
<pinref part="JP1" gate="A" pin="31"/>
<wire x1="38.1" y1="48.26" x2="60.96" y2="48.26" width="0.1524" layer="91"/>
<label x="38.1" y="48.26" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="31"/>
<wire x1="142.24" y1="48.26" x2="160.02" y2="48.26" width="0.1524" layer="91"/>
<label x="142.24" y="48.26" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A6" class="0">
<segment>
<pinref part="JP1" gate="A" pin="29"/>
<wire x1="38.1" y1="50.8" x2="60.96" y2="50.8" width="0.1524" layer="91"/>
<label x="38.1" y="50.8" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="29"/>
<wire x1="142.24" y1="50.8" x2="160.02" y2="50.8" width="0.1524" layer="91"/>
<label x="142.24" y="50.8" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="A7" class="0">
<segment>
<pinref part="JP1" gate="A" pin="27"/>
<wire x1="38.1" y1="53.34" x2="60.96" y2="53.34" width="0.1524" layer="91"/>
<label x="38.1" y="53.34" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="27"/>
<wire x1="142.24" y1="53.34" x2="160.02" y2="53.34" width="0.1524" layer="91"/>
<label x="142.24" y="53.34" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="!BANK0" class="0">
<segment>
<pinref part="JP1" gate="A" pin="9"/>
<wire x1="60.96" y1="76.2" x2="38.1" y2="76.2" width="0.1524" layer="91"/>
<label x="38.1" y="76.2" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="9"/>
<wire x1="142.24" y1="76.2" x2="160.02" y2="76.2" width="0.1524" layer="91"/>
<label x="142.24" y="76.2" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="!BANK1" class="0">
<segment>
<pinref part="JP1" gate="A" pin="7"/>
<wire x1="60.96" y1="78.74" x2="38.1" y2="78.74" width="0.1524" layer="91"/>
<label x="38.1" y="78.74" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="7"/>
<wire x1="142.24" y1="78.74" x2="160.02" y2="78.74" width="0.1524" layer="91"/>
<label x="142.24" y="78.74" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="!BANK2" class="0">
<segment>
<pinref part="JP1" gate="A" pin="5"/>
<wire x1="60.96" y1="81.28" x2="38.1" y2="81.28" width="0.1524" layer="91"/>
<label x="38.1" y="81.28" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="5"/>
<wire x1="142.24" y1="81.28" x2="160.02" y2="81.28" width="0.1524" layer="91"/>
<label x="142.24" y="81.28" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="!BANK3" class="0">
<segment>
<pinref part="JP1" gate="A" pin="3"/>
<wire x1="60.96" y1="83.82" x2="38.1" y2="83.82" width="0.1524" layer="91"/>
<label x="38.1" y="83.82" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="3"/>
<wire x1="142.24" y1="83.82" x2="160.02" y2="83.82" width="0.1524" layer="91"/>
<label x="142.24" y="83.82" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="!IOSEL" class="0">
<segment>
<pinref part="JP1" gate="A" pin="1"/>
<wire x1="60.96" y1="86.36" x2="38.1" y2="86.36" width="0.1524" layer="91"/>
<label x="38.1" y="86.36" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="1"/>
<wire x1="142.24" y1="86.36" x2="160.02" y2="86.36" width="0.1524" layer="91"/>
<label x="142.24" y="86.36" size="1.016" layer="95" rot="R180" xref="yes"/>
</segment>
</net>
<net name="GND" class="0">
<segment>
<pinref part="JP1" gate="A" pin="10"/>
<wire x1="91.44" y1="76.2" x2="76.2" y2="76.2" width="0.1524" layer="91"/>
<label x="91.44" y="76.2" size="1.016" layer="95" xref="yes"/>
<pinref part="JP1" gate="A" pin="8"/>
<wire x1="76.2" y1="76.2" x2="68.58" y2="76.2" width="0.1524" layer="91"/>
<wire x1="91.44" y1="78.74" x2="76.2" y2="78.74" width="0.1524" layer="91"/>
<label x="91.44" y="78.74" size="1.016" layer="95" xref="yes"/>
<wire x1="76.2" y1="78.74" x2="68.58" y2="78.74" width="0.1524" layer="91"/>
<wire x1="76.2" y1="76.2" x2="76.2" y2="78.74" width="0.1524" layer="91"/>
<junction x="76.2" y="76.2"/>
<junction x="76.2" y="78.74"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="10"/>
<wire x1="195.58" y1="76.2" x2="175.26" y2="76.2" width="0.1524" layer="91"/>
<label x="195.58" y="76.2" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="8"/>
<wire x1="195.58" y1="78.74" x2="175.26" y2="78.74" width="0.1524" layer="91"/>
<label x="195.58" y="78.74" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="VCC" class="0">
<segment>
<pinref part="JP1" gate="A" pin="4"/>
<wire x1="91.44" y1="83.82" x2="76.2" y2="83.82" width="0.1524" layer="91"/>
<label x="91.44" y="83.82" size="1.016" layer="95" xref="yes"/>
<pinref part="JP1" gate="A" pin="2"/>
<wire x1="76.2" y1="83.82" x2="68.58" y2="83.82" width="0.1524" layer="91"/>
<wire x1="91.44" y1="86.36" x2="76.2" y2="86.36" width="0.1524" layer="91"/>
<label x="91.44" y="86.36" size="1.016" layer="95" xref="yes"/>
<wire x1="76.2" y1="86.36" x2="68.58" y2="86.36" width="0.1524" layer="91"/>
<wire x1="76.2" y1="83.82" x2="76.2" y2="86.36" width="0.1524" layer="91"/>
<junction x="76.2" y="83.82"/>
<junction x="76.2" y="86.36"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="4"/>
<wire x1="195.58" y1="83.82" x2="175.26" y2="83.82" width="0.1524" layer="91"/>
<label x="195.58" y="83.82" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="2"/>
<wire x1="195.58" y1="86.36" x2="175.26" y2="86.36" width="0.1524" layer="91"/>
<label x="195.58" y="86.36" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D7" class="0">
<segment>
<pinref part="JP1" gate="A" pin="24"/>
<wire x1="91.44" y1="58.42" x2="68.58" y2="58.42" width="0.1524" layer="91"/>
<label x="91.44" y="58.42" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="24"/>
<wire x1="195.58" y1="58.42" x2="175.26" y2="58.42" width="0.1524" layer="91"/>
<label x="195.58" y="58.42" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D0" class="0">
<segment>
<pinref part="JP1" gate="A" pin="38"/>
<wire x1="91.44" y1="40.64" x2="68.58" y2="40.64" width="0.1524" layer="91"/>
<label x="91.44" y="40.64" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="38"/>
<wire x1="195.58" y1="40.64" x2="175.26" y2="40.64" width="0.1524" layer="91"/>
<label x="195.58" y="40.64" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D1" class="0">
<segment>
<pinref part="JP1" gate="A" pin="36"/>
<wire x1="91.44" y1="43.18" x2="68.58" y2="43.18" width="0.1524" layer="91"/>
<label x="91.44" y="43.18" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="36"/>
<wire x1="195.58" y1="43.18" x2="175.26" y2="43.18" width="0.1524" layer="91"/>
<label x="195.58" y="43.18" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D2" class="0">
<segment>
<pinref part="JP1" gate="A" pin="34"/>
<wire x1="91.44" y1="45.72" x2="68.58" y2="45.72" width="0.1524" layer="91"/>
<label x="91.44" y="45.72" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="34"/>
<wire x1="195.58" y1="45.72" x2="175.26" y2="45.72" width="0.1524" layer="91"/>
<label x="195.58" y="45.72" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D3" class="0">
<segment>
<pinref part="JP1" gate="A" pin="32"/>
<wire x1="91.44" y1="48.26" x2="68.58" y2="48.26" width="0.1524" layer="91"/>
<label x="91.44" y="48.26" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="32"/>
<wire x1="195.58" y1="48.26" x2="175.26" y2="48.26" width="0.1524" layer="91"/>
<label x="195.58" y="48.26" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D4" class="0">
<segment>
<pinref part="JP1" gate="A" pin="30"/>
<wire x1="91.44" y1="50.8" x2="68.58" y2="50.8" width="0.1524" layer="91"/>
<label x="91.44" y="50.8" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="30"/>
<wire x1="195.58" y1="50.8" x2="175.26" y2="50.8" width="0.1524" layer="91"/>
<label x="195.58" y="50.8" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D5" class="0">
<segment>
<pinref part="JP1" gate="A" pin="28"/>
<wire x1="91.44" y1="53.34" x2="68.58" y2="53.34" width="0.1524" layer="91"/>
<label x="91.44" y="53.34" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="28"/>
<wire x1="195.58" y1="53.34" x2="175.26" y2="53.34" width="0.1524" layer="91"/>
<label x="195.58" y="53.34" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="D6" class="0">
<segment>
<pinref part="JP1" gate="A" pin="26"/>
<wire x1="91.44" y1="55.88" x2="68.58" y2="55.88" width="0.1524" layer="91"/>
<label x="91.44" y="55.88" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="26"/>
<wire x1="195.58" y1="55.88" x2="175.26" y2="55.88" width="0.1524" layer="91"/>
<label x="195.58" y="55.88" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="RDY" class="0">
<segment>
<pinref part="JP1" gate="A" pin="12"/>
<wire x1="68.58" y1="73.66" x2="91.44" y2="73.66" width="0.1524" layer="91"/>
<label x="91.44" y="73.66" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="12"/>
<wire x1="195.58" y1="73.66" x2="175.26" y2="73.66" width="0.1524" layer="91"/>
<label x="195.58" y="73.66" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="RWB" class="0">
<segment>
<pinref part="JP1" gate="A" pin="22"/>
<wire x1="91.44" y1="60.96" x2="68.58" y2="60.96" width="0.1524" layer="91"/>
<label x="91.44" y="60.96" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="22"/>
<wire x1="195.58" y1="60.96" x2="175.26" y2="60.96" width="0.1524" layer="91"/>
<label x="195.58" y="60.96" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="RESB" class="0">
<segment>
<pinref part="JP1" gate="A" pin="18"/>
<wire x1="91.44" y1="66.04" x2="68.58" y2="66.04" width="0.1524" layer="91"/>
<label x="91.44" y="66.04" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="18"/>
<wire x1="195.58" y1="66.04" x2="175.26" y2="66.04" width="0.1524" layer="91"/>
<label x="195.58" y="66.04" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="IRQB" class="0">
<segment>
<pinref part="JP1" gate="A" pin="14"/>
<wire x1="91.44" y1="71.12" x2="68.58" y2="71.12" width="0.1524" layer="91"/>
<label x="91.44" y="71.12" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="14"/>
<wire x1="195.58" y1="71.12" x2="175.26" y2="71.12" width="0.1524" layer="91"/>
<label x="195.58" y="71.12" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="NMIB" class="0">
<segment>
<pinref part="JP1" gate="A" pin="16"/>
<wire x1="91.44" y1="68.58" x2="68.58" y2="68.58" width="0.1524" layer="91"/>
<label x="91.44" y="68.58" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="16"/>
<wire x1="195.58" y1="68.58" x2="175.26" y2="68.58" width="0.1524" layer="91"/>
<label x="195.58" y="68.58" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="OSC" class="0">
<segment>
<pinref part="JP1" gate="A" pin="6"/>
<wire x1="91.44" y1="81.28" x2="68.58" y2="81.28" width="0.1524" layer="91"/>
<label x="91.44" y="81.28" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="6"/>
<wire x1="195.58" y1="81.28" x2="175.26" y2="81.28" width="0.1524" layer="91"/>
<label x="195.58" y="81.28" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
<net name="PHI2" class="0">
<segment>
<pinref part="JP1" gate="A" pin="20"/>
<wire x1="91.44" y1="63.5" x2="68.58" y2="63.5" width="0.1524" layer="91"/>
<label x="91.44" y="63.5" size="1.016" layer="95" xref="yes"/>
</segment>
<segment>
<pinref part="SV1" gate="1" pin="20"/>
<wire x1="195.58" y1="63.5" x2="175.26" y2="63.5" width="0.1524" layer="91"/>
<label x="195.58" y="63.5" size="1.016" layer="95" xref="yes"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
<errors>
<approved hash="113,1,64.7277,63.6312,JP1,,,,,"/>
<approved hash="113,1,63.5,-2.73473,SV1,,,,,"/>
</errors>
</schematic>
</drawing>
</eagle>
