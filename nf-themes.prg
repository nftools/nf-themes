*******************************************************
* Marco Plaza, 2022
* @nfoxdev
* visualfoxpro color preferences
*******************************************************

_screen.addproperty('nfthemes',createobject('nfThemes'))



*************************************
define class nfthemes as form
*************************************

	showwindow  = 2
	borderstyle = 0
	maxbutton	= .f.
	minbutton	= .f.
	autocenter	= .t.
	alwaysontop	= .t.
	width		= 350
	height		= 410
	caption 	= 'nfTools - ( Click=FontColor RightClick=BackColor )'
	backcolor 	= rgb(100,100,100)

	add object pf as pageframe with ;
		left = 0, top = 0,height = 380,width=350,;
		themes=.f.,tabstyle=0,specialeffect=0,tabstretch=0,;
		borderwidth=0,pagecount=10


*--------------------------
	function init()
*--------------------------
	local foxreg
	local nexttop
	local kn
	local ntab
	local array atabnames(1)
	local array albls(1)

	text TO colorKeys NOSHOW PRETEXT 2+4+8
EditorVariableColor,EditorCommentColor,EditorKeyWordColor,EditorOperatorColor,EditorConstantColor,EditorStringColor,
TraceNormalColor,TraceExecutingColor,TraceCallStackColor,
TraceBreakpointColor,TraceSelectedColor,
WatchNormalColor,WatchSelectedColor,WatchChangedColor,
LocalsNormalColor,LocalsSelectedColor,
OutputNormalColor,OutputSelectedColor,
CallstackNormalColor,CallstackSelectedColor,
BookmarkColor,ShortcutColor
	ENDTEXT

	foxreg = newobject('foxreg',sys(2004)+'samples\classes\registry.prg')

	this.pf.pagecount = alines(atabnames,'Editor,Trace,Locals,Watch,Output,Callstack,Bookmark,Shortcut',1,',')

	for ntab = 1 to this.pf.pagecount

		nexttop		= 10

		with this.pf.pages(m.ntab)

			.caption = atabnames(m.ntab)
			.backcolor = rgb(100,100,100)
			.forecolor = rgb(255,255,255)

			for n = 1 to alines(albls,m.colorkeys,1,',')

				kn = albls(m.n)

				if kn = .caption
					.addobject(m.kn,'colorlbl',m.foxreg,m.kn,m.nexttop)
					nexttop = m.nexttop + .&kn..height + 3
				endif

			endfor

		endwith

	endfor

	this.visible = .t.


*****************************************
enddefine
******************************************

*******************************************
define class colorlbl as label
*******************************************

	visible		= .t.
	fontsize	= 12
	fontname	= 'Segoe UI'
	alignment	= 2
	foxreg		= .f.
	height		= 50
	left 		= 10
	specialeffect=2
	colorKeyname= ''
	fontKeyname=''


*-----------------------------------------------------------
	procedure init( foxreg,colorkeyname,top,tabname )
*----------------------------------------------------------

	this.foxreg = m.foxreg

	local regval
	local array ac(1)


	regval = ''
	foxreg.getfoxoption(m.colorkeyname,@regval)

	if alines(ac,strextract(m.regval,'RGB(',')',1,1),1,',') # 6
		dimension ac(6)
		store '0'   to ac(1),ac(2),ac(3)
		store '255' to ac(4),ac(5),ac(6)
	endif

	with this
		.caption	= m.colorkeyname 
		.colorKeyname	= m.colorkeyName
		.top		= m.top
		.forecolor	= rgb(&ac(1),&ac(2),&ac(3))
		.backcolor	= rgb(&ac(4),&ac(5),&ac(6))
		.width 		= thisform.width-20
	endwith


*----------------------------------------------------------
	function mouseup(nbutton, nshift, nxcoord, nycoord)
*----------------------------------------------------------



	local newcolor
	local csp
	local fred,fgreen,fblue,bred,bgreen,bblue
	
	newcolor =  getcolor()

	if m.newcolor = -1
		return
	endif


	if m.nbutton=1
		this.forecolor = m.newcolor
	else
		this.backcolor = m.newcolor
	endif

	store '' to fred,fgreen,fblue,bred,bgreen,bblue
	this.color2rgb( this.forecolor, @m.fred,@m.fgreen,@m.fblue)
	this.color2rgb( this.backcolor, @m.bred,@m.bgreen,@m.bblue)

	this.foxreg.setfoxoption(this.colorKeyName,textmerge('RGB(<<m.fred>>,<<m.fgreen>>,<<m.fblue>>,<<m.bred>>,<<m.bgreen>>,<<m.bblue>>), NoAuto, NoAuto')) &&

	local csp
	csp = set('path')
	sys(3056)
	set path to (m.csp)

*---------------------------------------------------
	procedure color2rgb( tncolor, r , g, b )
*---------------------------------------------------
	r = bitrshift(bitand(tncolor, 0x0000ff),0)
	g = bitrshift(bitand(tncolor, 0x00ff00),8)
	b = bitrshift(bitand(tncolor, 0xff0000),16)

******************************************
enddefine
******************************************

