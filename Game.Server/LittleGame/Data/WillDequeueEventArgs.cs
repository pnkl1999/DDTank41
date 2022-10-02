using System;

namespace Game.Server.LittleGame.Data
{
    public class WillDequeueEventArgs<T> : EventArgs
    {
        public T ItemToBeDequeued { get; }

        public WillDequeueEventArgs(T itemToBeDequeued)
        {
			ItemToBeDequeued = itemToBeDequeued;
        }
    }
}
