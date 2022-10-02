using System;

namespace Game.Server.LittleGame.Data
{
    public class DidDequeueEventArgs<T> : EventArgs
    {
        public T DequeuedItem { get; }

        public T NextItem { get; }

        public DidDequeueEventArgs(T dequeuedItem, T nextItem)
        {
			DequeuedItem = dequeuedItem;
			NextItem = nextItem;
        }
    }
}
