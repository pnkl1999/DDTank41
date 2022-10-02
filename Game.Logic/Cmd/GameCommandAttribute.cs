using System;

namespace Game.Logic.Cmd
{
    public class GameCommandAttribute : Attribute
    {
        private int m_code;

        private string m_description;

        public int Code=> m_code;

        public string Description=> m_description;

        public GameCommandAttribute(int code, string description)
        {
			m_code = code;
			m_description = description;
        }
    }
}
