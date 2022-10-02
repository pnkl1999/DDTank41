namespace Game.Base.Events
{
    public abstract class RoadEvent
    {
        protected string m_EventName;

        public string Name=> m_EventName;

        public RoadEvent(string name)
        {
			m_EventName = name;
        }

        public virtual bool IsValidFor(object o)
        {
			return true;
        }

        public override string ToString()
        {
			return "DOLEvent(" + m_EventName + ")";
        }
    }
}
