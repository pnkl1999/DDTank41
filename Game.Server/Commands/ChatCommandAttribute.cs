using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.Commands
{
    class ChatCommandAttribute : Attribute
    {
        public ChatCommandAttribute(string code, string description, AccessLevel level)
        {
            Command = code;
            Description = description;
            Level = level;
        }

        public string Command { get; }

        public string Description { get; }

        public AccessLevel Level { get; }
    }
}
