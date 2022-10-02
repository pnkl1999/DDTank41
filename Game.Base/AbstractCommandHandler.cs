namespace Game.Base
{
    public abstract class AbstractCommandHandler
    {
        public virtual void DisplayMessage(BaseClient client, string format, params object[] args)
        {
			DisplayMessage(client, string.Format(format, args));
        }

        public virtual void DisplayMessage(BaseClient client, string message)
        {
			client?.DisplayMessage(message);
        }

        public virtual void DisplaySyntax(BaseClient client)
        {
			if (client == null)
			{
				return;
			}
			CmdAttribute[] attrib = (CmdAttribute[])GetType().GetCustomAttributes(typeof(CmdAttribute), inherit: false);
			if (attrib.Length != 0)
			{
				client.DisplayMessage(attrib[0].Description);
				string[] usage = attrib[0].Usage;
				string[] array = usage;
				foreach (string str in array)
				{
					client.DisplayMessage(str);
				}
			}
        }
    }
}
