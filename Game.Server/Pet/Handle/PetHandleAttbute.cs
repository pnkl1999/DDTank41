using System;

namespace Game.Server.Pet.Handle
{
    class PetHandleAttbute : Attribute
    {
        public byte Code { get; private set; }

        public PetHandleAttbute(byte code)
        {
            Code = code;
        }
    }
}