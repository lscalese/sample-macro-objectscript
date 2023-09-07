Class dc.Projection Extends %Projection.AbstractProjection [ System = 3 ]
{

ClassMethod CreateProjection(
	classname As %String,
	ByRef parameters As %String,
	modified As %String,
	qstruct) As %Status
{
    Set routine = "OnCompileParam.mac" 
    Do:##class(%Library.Routine).Exists(routine) ##class(%Library.Routine).CompileList(routine,"c-d")
	QUIT $$$OK
}

}
