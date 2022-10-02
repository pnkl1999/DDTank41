using System;

namespace Game.Server.Farm
{
    public class FarmProcessorAtribute : Attribute
    {
        private byte _code;

        private string _descript;

        public byte Code=> _code;

        public string Description=> _descript;

        public FarmProcessorAtribute(byte code, string description)
        {
			_code = code;
			_descript = description;
        }
    }
}
