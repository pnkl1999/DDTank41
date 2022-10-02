namespace Game.Base
{
    public interface ICommandHandler
    {
        bool OnCommand(BaseClient client, string[] args);
    }
}
