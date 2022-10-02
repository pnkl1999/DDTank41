using System;
using System.Collections.Generic;

namespace Game.Server.LittleGame.Data
{
    public class TriggeredQueue<T, TOwner>
    {
        private readonly Queue<T> queue = new Queue<T>();

        public int Count=> queue.Count;

        public bool IsEmpty=> queue.Count < 1;

        public TOwner Owner { get; }

        public event WillEnqueueEventHandler<T> WillEnqueue;

        public event WillDequeueEventHandler<T> WillDequeue;

        public event DidEnqueueEventHandler<T> DidEnqueue;

        public event DidDequeueEventHandler<T> DidDequeue;

        public TriggeredQueue(TOwner owner)
        {
			Owner = owner;
        }

        protected virtual void OnWillEnqueue(T currentHeadOfQueue, T itemToEnqueue)
        {
			if (Owner != null)
			{
				this.WillEnqueue?.Invoke(Owner, new WillEnqueueEventArgs<T>(currentHeadOfQueue, itemToEnqueue));
			}
			else
			{
				this.WillEnqueue?.Invoke(this, new WillEnqueueEventArgs<T>(currentHeadOfQueue, itemToEnqueue));
			}
        }

        protected virtual void OnDidEnqueue(T enqueuedItem, T previousHeadOfQueue)
        {
			if (Owner != null)
			{
				this.DidEnqueue?.Invoke(Owner, new DidEnqueueEventArgs<T>(enqueuedItem, previousHeadOfQueue));
			}
			else
			{
				this.DidEnqueue?.Invoke(this, new DidEnqueueEventArgs<T>(enqueuedItem, previousHeadOfQueue));
			}
        }

        protected virtual void OnWillDequeue(T itemToBeDequeued)
        {
			if (Owner != null)
			{
				this.WillDequeue?.Invoke(Owner, new WillDequeueEventArgs<T>(itemToBeDequeued));
			}
			else
			{
				this.WillDequeue?.Invoke(this, new WillDequeueEventArgs<T>(itemToBeDequeued));
			}
        }

        protected virtual void OnDidDequeue(T dequeuedItem, T nextItem)
        {
			if (Owner != null)
			{
				this.DidDequeue?.Invoke(Owner, new DidDequeueEventArgs<T>(dequeuedItem, nextItem));
			}
			else
			{
				this.DidDequeue?.Invoke(this, new DidDequeueEventArgs<T>(dequeuedItem, nextItem));
			}
        }

        public virtual void Enqueue(T item)
        {
			T val;
			try
			{
				val = queue.Peek();
			}
			catch (InvalidOperationException)
			{
				val = default(T);
			}
			OnWillEnqueue(val, item);
			queue.Enqueue(item);
			OnDidEnqueue(item, val);
        }

        public virtual T Dequeue()
        {
			T itemToBeDequeued;
			try
			{
				itemToBeDequeued = queue.Peek();
			}
			catch (InvalidOperationException)
			{
				itemToBeDequeued = default(T);
			}
			OnWillDequeue(itemToBeDequeued);
			T val = queue.Dequeue();
			try
			{
				itemToBeDequeued = queue.Peek();
			}
			catch (InvalidOperationException)
			{
				itemToBeDequeued = default(T);
			}
			OnDidDequeue(val, itemToBeDequeued);
			return val;
        }

        public Queue<T>.Enumerator GetEnumerator()
        {
			return queue.GetEnumerator();
        }

        public T Peek()
        {
			return (!IsEmpty) ? queue.Peek() : default(T);
        }

        public void Clear()
        {
			queue.Clear();
        }
    }
}
