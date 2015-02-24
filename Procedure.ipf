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


function bar(m,n)
	variable m,n
	
	make/N=1/O w1
	make/N=1/O w2
	make/N=1/O w3
	make/N=1/O w4
	make/N=1/O w5
	make/N=1/O w6
	
	wave e11 = $"E11_n"+num2str(n)
	wave e22 = $"E22_n"+num2str(n)
	
	w1 = e11[m]
	w2 = e22[m]
	
	
	
	//w3 = c11[4]
	//w4 = c22[4]
end

function g()
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

function appendgraph0(w)
	string w
	DoWindow/F graph0
	appendToGraph w4 vs w3
	color("w4", 0, 255, 0)
	
	DoWindow/F graph0
	appendToGraph w6 vs w5
	color("w6", 0, 0, 255)
end

Window Graph0() : Graph
	resetGraph0()
	display w2 vs w1
	style_Wave()
	color("w2", 255, 0, 0)
	appendtograph w4 vs w3
	appendtograph w6 vs w5
	
	//color1("w4", 0, 255, 0)
end


function init()
	
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
	//bar(2,m0, n0)
	
	make/N=1/O w1
	make/N=1/O w2
	
	wave e11 = $"E11_n"+num2str(n0)
	wave e22 = $"E22_n"+num2str(n0)
	
	w1 = e11[m0]
	w2 = e22[m0]
End

Function ButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
	NVAR/Z n1,m1
	//bar(4,m1, n1)
	appendgraph0("w4")
	
	make/N=1/O w3
	make/N=1/O w4
	
	wave e11 = $"E11_n"+num2str(n1)
	wave e22 = $"E22_n"+num2str(n1)
	
	w3 = e11[m1]
	w4 = e22[m1]
End

Function ButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
	NVAR/Z n2,m2
	//bar(6,m2, n2)
	
	make/N=1/O w5
	make/N=1/O w6
	
	wave e11 = $"E11_n"+num2str(n2)
	wave e22 = $"E22_n"+num2str(n2)
	
	w5 = e11[m2]
	w6 = e22[m2]
	
	appendgraph0("w6")
End
