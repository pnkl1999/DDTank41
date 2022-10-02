namespace Game.Logic
{
    public class MacroDropInfo
    {
        public int DropCount { get; set; }

        public int MaxDropCount { get; set; }

        public int SelfDropCount { get; set; }

        public MacroDropInfo(int dropCount, int maxDropCount)
        {
			DropCount = dropCount;
			MaxDropCount = maxDropCount;
        }
    }
}
