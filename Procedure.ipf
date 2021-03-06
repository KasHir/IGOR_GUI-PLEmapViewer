// ==================================================
// GUI-PLEmapViewer
//  - Auth: KasHir
//  - since 2015/2/22
//
// [GitHub]
//  - https://github.com/KasHir/IGOR_GUI-PLEmapViewer
// =================================================
#pragma rtGlobals=1		// Use modern global access method.

// ----------------------------------
//  PLE map Graph
// ----------------------------------
Window Graph0() : Graph
	resetGraph("Graph0")
	display w_e22 vs w_e11
	style_dummyPlot("w_e22")
	style_Wave()
	
	// plot the other points
	appendGraph0()
end

// ----------------------------------
//  Coherent phonon map Graph
// ----------------------------------
Window Graph1() : Graph
	resetGraph("Graph1")
	display o_e22 vs o_e
	style_dummyPlot("o_e22")
	appendToGraph o_e11 vs o_e
	style_dummyPlot("o_e11")
	
	style_Omg()	
	
	appendToGraph o0_e22 vs o0
	color("o0_e22", E22_R[0], E22_G[0], E22_B[0])
	appendToGraph o0_e11 vs o0
	color("o0_e11", E11_R[0], E11_G[0], E11_B[0])

	appendToGraph o1_e22 vs o1
	color("o1_e22", E22_R[1], E22_G[1], E22_B[1])
	appendToGraph o1_e11 vs o1
	color("o1_e11", E11_R[1], E11_G[1], E11_B[1])

	appendToGraph o2_e22 vs o2
	color("o2_e22", E22_R[2], E22_G[2], E22_B[2])
	appendToGraph o2_e11 vs o2
	color("o2_e11", E11_R[2], E11_G[2], E11_B[2])
end


// If Graph exists already, Kill it once
function resetGraph(g)
	string g
	DoWindow $g
	if (V_flag == 1)
		// graph window exist
		dowindow/k $g	// kill Graph
		return 1
	else
		// graph window unexist
		return 0
	endif
end

// ----------------------------------
//  GET Value Function
// ----------------------------------
function getE11(n, m)
	variable n,m
	wave e11 = $"E11_n"+num2str(n) 
	
	if( e11[m] > 0)
		return e11[m]
	else
		return -1
	endif
end

function getE22(n, m)
	variable n,m
	wave e22 = $"E22_n"+num2str(n)
	
	if( e22[m] > 0 )
		return e22[m]
	else
		return -1
	endif
end

function getOmega(n, m)
	variable n,m
	wave omega = $"Omg_n"+num2str(n)
	
	if( omega[m] > 0 )
		return omega[m]
	else
		return -1
	endif
end

// ----------------------------------
//  style
// ----------------------------------
function style_E()
	// unused now
end

function style_Wave()
	ModifyGraph grid=1,tick=2,mirror=1,gridHair=3;DelayUpdate
	Label left "E22 (nm)";DelayUpdate
	Label bottom "E11 (nm)";DelayUpdate
	SetAxis left 0,3000;DelayUpdate
	SetAxis bottom 0,3000;DelayUpdate
	ModifyGraph height={Aspect,1}
end

function style_Omg()
	ModifyGraph grid=1,tick=2,mirror=1,gridHair=3;DelayUpdate
	Label left "E11, E22 (nm)";DelayUpdate
	Label bottom "Omega_RBM (cm^-1)";DelayUpdate
	SetAxis left 0,3000;DelayUpdate
	SetAxis bottom 0,600;DelayUpdate
	ModifyGraph height={Aspect,1}
end

function style_dummyPlot(w)
	string w
	color(w, 200, 200, 200)
	ModifyGraph marker($w)=8	
	ModifyGraph useMrkStrokeRGB($w)=0
end

function color(w, r,g,b)
	string w		//wave name
	variable r,g,b	// R,G,B; 0 to 255
	ModifyGraph mode($w)=3,marker($w)=19,msize($w)=4,rgb($w)=(r/255*65280,g/255*65280,b/255*65280)
	ModifyGraph useMrkStrokeRGB($w)=1
end

function appendGraph0()
	wave r = E22_R
	wave g = E22_G
	wave b = E22_B
	// append C(n0,m0)
	DoWindow/F graph0	// select target graph
	appendToGraph w1 vs w0
	color("w1", r[0], g[0], b[0])

	// append C(n1,m1)
	DoWindow/F graph0	// select target graph
	appendToGraph w3 vs w2
	color("w3", r[1], g[1], b[1])	
	
	// append C(n2, m2)
	DoWindow/F graph0	// select target graph
	appendToGraph w5 vs w4
	color("w5",  r[2], g[2], b[2])	
end

// ----------------------------------
//   Functions on GUI
// ----------------------------------
Function Get_Data(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR/Z n0,m0,n1,m1,n2,m2
	
	updateValues0()	// red
	updateValues1()	// green
	updateValues2()	// blue
	
	chkValue()
End

function chkValue()
	NVAR/Z n0,m0,n1,m1,n2,m2
	if( getE11(n0, m0) == -1 || getE22(n0, m0) == -1)
		Button button0 disable=2	// disable
	else
		Button button0 disable=0	// enable
	endif

	if( getE11(n1, m1) == -1 || getE22(n1, m1) == -1)
		Button button1 disable=2	// disable
	else
		Button button1 disable=0	// enable
	endif
	
	if( getE11(n2, m2) == -1 || getE22(n2, m2) == -1 )
		Button button2 disable=2	// disable
	else
		Button button2 disable=0	// enable
	endif

end

Function ButtonProc(ctrlName) : ButtonControl
	String ctrlName
	updateValues0()	// update red point
End

Function ButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
	updateValues1()	// update green point
End

Function ButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
	updateValues2()	// update blue point
End

// ----------------------------------
//  Update values for wave
// ----------------------------------
function updateValues0()
	NVAR/Z n0,m0
	
	// E11, E22; PLE map
	make/N=1/O w0
	make/N=1/O w1
	
	w0 = getE11(n0, m0)
	w1 = getE22(n0, m0)
	
	// Omega; coherent phonon map
	make/N=1/O o0
	make/N=1/O o0_e11
	make/N=1/O o0_e22
	
	o0 = getOmega(n0, m0)
	o0_e11 = getE11(n0, m0)
	o0_e22 = getE22(n0, m0)
end

function updateValues1()
	NVAR/Z n1, m1
	
	// E11, E22; PLE map
	make/N=1/O w2
	make/N=1/O w3
	
	w2 = getE11(n1, m1)
	w3 = getE22(n1, m1)
	
	// Omega; coherent phonon map
	make/N=1/O o1
	make/N=1/O o1_e11
	make/N=1/O o1_e22
	
	o1 = getOmega(n1, m1)
	o1_e11 = getE11(n1, m1)
	o1_e22 = getE22(n1, m1)
end

function updateValues2()
	NVAR/Z n2,m2
	
	// E11, E22; PLE map
	make/N=1/O w4
	make/N=1/O w5
	
	w4 = getE11(n2, m2)
	w5 = getE22(n2, m2)
	
	// Omega; coherent phonon map
	make/N=1/O o2
	make/N=1/O o2_e11
	make/N=1/O o2_e22
	
	o2 = getOmega(n2, m2)
	o2_e11 = getE11(n2, m2)
	o2_e22 = getE22(n2, m2)
end

// ----------------------------------
//  Substitution values for wave
// ----------------------------------
function dummyE22vsE11()	// once is enough
	make/N=180/O w_e11	// dummy
	make/N=180/O w_e22	// dummy
	variable i = 0
	variable n = 19
	variable m = 0
	do
		m=0
		do
			w_e11[i] = getE11(n, m)
			w_e22[i] = getE22(n, m)
			i = i+1
			m = m+1
		while(m<n)
		n = n-1
	while(n>4)
end

function dummyEvsOmega()	// once is enough
	make/N=180/O o_e
	make/N=180/O o_e11	// dummy
	make/N=180/O o_e22	// dummy
	variable i = 0
	variable n = 19
	variable m = 0
	do
		m=0
		do
			o_e[i] = getOmega(n, m)
			o_e11[i] = getE11(n, m)
			o_e22[i] = getE22(n, m)
			i = i+1
			m = m+1
		while(m<n)
		n = n-1
	while(n>4)
end