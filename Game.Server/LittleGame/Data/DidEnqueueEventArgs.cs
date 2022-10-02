using System;

namespace Game.Server.LittleGame.Data
{
    public class DidEnqueueEventArgs<T> : EventArgs
    {
        public T EnqueuedItem { get; }

        public T PreviousHeadOfQueue { get; }

        public DidEnqueueEventArgs(T enqueuedItem, T previousHeadOfQueue)
        {
			EnqueuedItem = enqueuedItem;
			PreviousHeadOfQueue = previousHeadOfQueue;
        }
    }
}
