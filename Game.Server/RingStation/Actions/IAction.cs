namespace Game.Server.RingStation.Action
{
    public interface IAction
    {
        void Execute(VirtualGamePlayer player, long tick);

        bool IsFinished(long tick);
    }
}