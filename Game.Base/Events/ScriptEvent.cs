namespace Game.Base.Events
{
    public class ScriptEvent : RoadEvent
    {
        public static readonly ScriptEvent Loaded = new ScriptEvent("Script.Loaded");

        public static readonly ScriptEvent Unloaded = new ScriptEvent("Script.Unloaded");

        protected ScriptEvent(string name)
			: base(name)
        {
        }
    }
}
