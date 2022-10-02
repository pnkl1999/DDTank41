using Bussiness;
using Bussiness.Managers;
using Game.Base;
using System.Linq;
using System.Text;

namespace Game.Server.Commands.Admin
{
    [Cmd("&load", ePrivLevel.Player, "Load the metedata.", new string[]
	{
		"   /load  [option]...  ",
		"Option:    /config     :Application config file.",
		"           /shop       :ShopMgr.ReLoad().",
		"           /item       :ItemMgr.Reload().",
		"           /property   :Game properties."
	})]
	public class ReloadCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
			if (args.Length > 1)
			{
				StringBuilder stringBuilder = new StringBuilder();
				StringBuilder stringBuilder2 = new StringBuilder();
				if (args.Contains("/cmd"))
				{
					CommandMgr.LoadCommands();
					DisplayMessage(client, "Command load success!");
					stringBuilder.Append("/cmd,");
				}
				if (args.Contains("/config"))
				{
					GameServer.Instance.Configuration.Refresh();
					DisplayMessage(client, "Application config file load success!");
					stringBuilder.Append("/config,");
				}
				if (args.Contains("/property"))
				{
					GameProperties.Refresh();
					DisplayMessage(client, "Game properties load success!");
					stringBuilder.Append("/property,");
				}
				if (args.Contains("/item"))
				{
					if (ItemMgr.ReLoad())
					{
						DisplayMessage(client, "Items load success!");
						stringBuilder.Append("/item,");
					}
					else
					{
						DisplayMessage(client, "Items load failed!");
						stringBuilder2.Append("/item,");
					}
				}
				if (args.Contains("/shop"))
				{
					if (ItemMgr.ReLoad())
					{
						DisplayMessage(client, "Shops load success!");
						stringBuilder.Append("/shop,");
					}
					else
					{
						DisplayMessage(client, "Shops load failed!");
						stringBuilder2.Append("/shop,");
					}
				}
				if (stringBuilder.Length == 0 && stringBuilder2.Length == 0)
				{
					DisplayMessage(client, "Nothing executed!");
					DisplaySyntax(client);
				}
				else
				{
					DisplayMessage(client, "Success Options:    " + stringBuilder.ToString());
					if (stringBuilder2.Length > 0)
					{
						DisplayMessage(client, "Faile Options:      " + stringBuilder2.ToString());
						return false;
					}
				}
				return true;
			}
			DisplaySyntax(client);
			return true;
        }
    }
}
