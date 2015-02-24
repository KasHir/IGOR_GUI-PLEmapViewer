// ==================================================
// GUI-PLEmapViewer
//  - Auth: KasHir
//  - since 2015/2/22
//
// [GitHub]
//  - https://github.com/KasHir/IGOR_GUI-PLEmapViewer
// =================================================
#pragma rtGlobals=1		// Use modern global access method.

Window Graph0() : Graph
	resetGraph("Graph0")
	display w1 vs w0
	style_Wave()
	color("w1", 255, 0, 0)
	
	// plot the other points
	appendGraph0()
end

// ----------------------------------
//  Coherent phonon map Graph
// ----------------------------------
Window Graph1() : Graph
	resetGraph("Graph1")
	display o0_e22 vs o0
	style_Omg()	
	color("o0_e22", 255, 0, 0)
	appendToGraph o0_e11 vs o0
	color("o0_e11", 200, 0, 0)

	appendToGraph o1_e22 vs o1
	color("o1_e22", 0, 255, 0)
	appendToGraph o1_e11 vs o1
	color("o1_e11", 0, 200, 0)

	appendToGraph o2_e22 vs o2
	color("o2_e22", 0, 0, 255)
	appendToGraph o2_e11 vs o2
	color("o2_e11", 0, 0, 200)
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

function color(w, r,g,b)
	string w		//wave name
	variable r,g,b	// R,G,B; 0 to 255
	ModifyGraph mode($w)=3,marker($w)=19,msize($w)=4,rgb($w)=(r/255*65280,g/255*65280,b/255*65280)
end

function appendGraph0()
	// append C(n1,m1)
	DoWindow/F graph0	// select target graph
	appendToGraph w3 vs w2
	color("w3", 0, 255, 0)	// green
	
	// append C(n2, m2)
	DoWindow/F graph0	// select target graph
	appendToGraph w5 vs w4
	color("w5", 0, 0, 255)	// blue
end

/////////////////////////////////////
// Functions on GUI
/////////////////////////////////////

Function Get_Data(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR/Z n0,m0,n1,m1,n2,m2
	
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
End

Function ButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
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
End

Function ButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
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
End
