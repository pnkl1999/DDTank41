using System;

namespace Game.Server.WorldBoss
{
    public class WorldBossAttribute : Attribute
    {
        private byte _code;

        private string _descript;

        public WorldBossAttribute(byte code, string description)
        {
            _code = code;

            _descript = description;
        }

        public byte Code
        {
            get { return _code; }
        }

        public string Description
        {
            get { return _descript; }
        }
    }
}