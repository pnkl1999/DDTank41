using System;

namespace Game.Server.LittleGame.Data
{
    public class WillEnqueueEventArgs<T> : EventArgs
    {
        public T CurrentHeadOfQueue { get; }

        public T ItemToEnqueue { get; }

        public WillEnqueueEventArgs(T currentHeadOfQueue, T itemToEnqueue)
        {
			ItemToEnqueue = itemToEnqueue;
			CurrentHeadOfQueue = currentHeadOfQueue;
        }
    }
}
