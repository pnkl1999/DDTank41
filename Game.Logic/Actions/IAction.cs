namespace Game.Logic.Actions
{
    public interface IAction
    {
        void Execute(BaseGame game, long tick);

        bool IsFinished(long tick);
    }
}
