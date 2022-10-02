namespace Game.Server.LittleGame.Data
{
    public delegate void DidEnqueueEventHandler<T>(object sender, DidEnqueueEventArgs<T> e);
}
