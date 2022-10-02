using System;

namespace Game.Base.Events
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
	public class ScriptUnloadedEventAttribute : Attribute
    {
    }
}
