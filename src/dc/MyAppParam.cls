Class dc.MyAppParam Extends %Persistent
{

Property Label As %String(MAXLEN = "");

Property Key As %String(MAXLEN = 256) [ Required ];

Property Value As %String(MAXLEN = "");

Property ExistsInCode As %Boolean [ Calculated, SqlComputeCode = { Set {*} = ''$Data(^["^^"_$$GetDBRoutines^OnCompileParam()]MyAppParam({Key}))}, SqlComputed, Transient ];

Index UniqueI On Key [ Unique ];

ClassMethod Get(
	Key As %String,
	DefaultValue As %String = "") As %String
{
    Quit:'..UniqueIExists(Key, .id) DefaultValue
    Quit ..ValueGetStored(id)
}

ClassMethod Set(
	Key As %String,
	Value As %String,
	Label As %String = "") As %Status
{
    If '..UniqueIExists(Key, .id) {
        Set param = ..%New(), param.Key = Key, param.Label = Label, param.Value = Value
        Quit param.%Save()
    }

    Set param = ..%OpenId(id), param.Value = Value
    Set:Label'="" param.Label = Label

    Quit param.%Save()
}

Method ExistsInCodeGet() As %Boolean [ CodeMode = expression ]
{
''$Data(^["^^"_$$GetDBRoutines^OnCompileParam()]MyAppParam(..Key))
}

Query CompiledParameter() As %Query(ROWSPEC = "Key:%String,DefaultValue:%String,ExistsInParamTable:%Boolean") [ SqlProc ]
{
}

ClassMethod CompiledParameterExecute(
	ByRef qHandle As %Binary,
	Filter As %DynamicObject) As %Status
{
    Set qHandle("Key") = "", qHandle("dbref") = "^^"_$$GetDBRoutines^OnCompileParam()
    Quit $$$OK
}

ClassMethod CompiledParameterFetch(
	ByRef qHandle As %Binary,
	ByRef Row As %List,
	ByRef AtEnd As %Boolean) As %Status [ PlaceAfter = CompiledParameterExecute ]
{
    Set qHandle("Key") = $Order(^[qHandle("dbref")]MyAppParam(qHandle("Key")), 1, data)

    If qHandle("Key") = "" Set AtEnd = $$$YES, Row = "" Quit $$$OK

    Set Row = $Lb($Lg(data,1),$Lg(data,2),..UniqueIExists(qHandle("Key"))), AtEnd = $$$NO

    Quit $$$OK
}

ClassMethod CompiledParameterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CompiledParameterExecute ]
{
	Kill qHandle Quit $$$OK
}

Storage Default
{
<Data name="MyAppParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Label</Value>
</Value>
<Value name="3">
<Value>Key</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^dc.MyAppParamD</DataLocation>
<DefaultData>MyAppParamDefaultData</DefaultData>
<IdLocation>^dc.MyAppParamD</IdLocation>
<IndexLocation>^dc.MyAppParamI</IndexLocation>
<StreamLocation>^dc.MyAppParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
