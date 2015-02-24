#pragma rtGlobals=1		// Use modern global access method.

// If Graph 0 exists already, Kill it once
function resetGraph0()
	DoWindow Graph0
	if (V_flag == 1)
		// graph window exist
		dowindow/k Graph0	// kill Graph0
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


function style_E()
	ModifyGraph grid=1,tick=2,mirror=1,gridHair=3;DelayUpdate
	Label left "E (eV)";DelayUpdate
	Label bottom "E (eV)";DelayUpdate
	SetAxis left 0,3000;DelayUpdate
	SetAxis bottom 0,3000;DelayUpdate
	ModifyGraph height={Aspect,1}
end

function style_Wave()
	ModifyGraph grid=1,tick=2,mirror=1,gridHair=3;DelayUpdate
	Label left "E22 (nm)";DelayUpdate
	Label bottom "E11 (nm)";DelayUpdate
	SetAxis left 0,3000;DelayUpdate
	SetAxis bottom 0,3000;DelayUpdate
	ModifyGraph height={Aspect,1}
end

function color(w, r,g,b)
	string w
	variable r,g,b
	ModifyGraph mode($w)=3,marker($w)=19,msize($w)=4,rgb($w)=(r/255*65280,g/255*65280,b/255*65280)
end

function appendgraph0()
	DoWindow/F graph0
	appendToGraph w3 vs w2
	color("w3", 0, 255, 0)
	
	DoWindow/F graph0
	appendToGraph w5 vs w4
	color("w5", 0, 0, 255)
end

Window Graph0() : Graph
	resetGraph0()
	display w1 vs w0
	style_Wave()
	color("w1", 255, 0, 0)
	appendtograph w3 vs w2
	appendtograph w5 vs w4
	appendgraph0()
	
end


Function Get_Data(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR n0,m0,n1,m1,n2,m2
End


Function ButtonProc(ctrlName) : ButtonControl
	String ctrlName
	NVAR/Z n0,m0
	
	make/N=1/O w0
	make/N=1/O w1
	
	w0 = getE11(n0, m0)
	w1 = getE22(n0, m0)
End

Function ButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
	NVAR/Z n1, m1
	
	make/N=1/O w2
	make/N=1/O w3
	
	w2 = getE11(n1, m1)
	w3 = getE22(n1, m1)
End

Function ButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
	NVAR/Z n2,m2
	
	make/N=1/O w4
	make/N=1/O w5
	
	w4 = getE11(n2, m2)
	w5 = getE22(n2, m2)
End
