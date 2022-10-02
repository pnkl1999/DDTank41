namespace Game.Server.LittleGame.Data
{
    public delegate void WillDequeueEventHandler<T>(object sender, WillDequeueEventArgs<T> e);
}
