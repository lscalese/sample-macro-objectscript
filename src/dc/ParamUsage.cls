Include MyAppParam

Class dc.ParamUsage
{

ClassMethod TestGetAppParam()
{
    Set x = $$$GetAppParam("test.key", "DefaultValue")
    Set x = $$$GetAppParam("test.key2", "DefaultValue")
}

}
