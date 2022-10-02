namespace Game.Server.LittleGame.Data
{
    public delegate void WillEnqueueEventHandler<T>(object sender, WillEnqueueEventArgs<T> e);
}
