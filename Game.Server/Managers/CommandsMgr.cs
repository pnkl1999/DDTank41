using Bussiness;
using System.Collections.Generic;

namespace Game.Server.Managers
{
    public class CommandsMgr
    {
        private static Dictionary<int, List<string>> Commands;

        public static bool CheckAdmin(int UserID, string Command)
        {
			return Commands.ContainsKey(UserID);
        }

        public static bool Init()
        {
			Commands = new PlayerBussiness().LoadCommands();
			if (Commands != null)
			{
				return Commands.Count > 0;
			}
			return false;
        }
    }
}
