using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.Commands
{
    public class ChatCommandKey
    {
        public ChatCommandKey(string command, AccessLevel level)
        {
            Command = command;
            Level = level;
        }

        public string Command { get; set; }
        public AccessLevel Level { get; set; }
    }
}
