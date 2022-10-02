namespace Game.Base
{
    public class GameCommand
    {
        public string[] m_usage;

        public string m_cmd;

        public uint m_lvl;

        public string m_desc;

        public ICommandHandler m_cmdHandler;
    }
}
