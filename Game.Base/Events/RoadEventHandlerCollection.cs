using log4net;
using System;
using System.Collections.Specialized;
using System.Reflection;
using System.Threading;

namespace Game.Base.Events
{
    public class RoadEventHandlerCollection
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected readonly HybridDictionary m_events = new HybridDictionary();

        protected readonly ReaderWriterLock m_lock = new ReaderWriterLock();

        protected const int TIMEOUT = 3000;

        public void AddHandler(RoadEvent e, RoadEventHandler del)
        {
			try
			{
				m_lock.AcquireWriterLock(3000);
				try
				{
					WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)m_events[e];
					if (weakDelegate == null)
					{
						m_events[e] = new WeakMulticastDelegate(del);
					}
					else
					{
						m_events[e] = WeakMulticastDelegate.Combine(weakDelegate, del);
					}
				}
				finally
				{
					m_lock.ReleaseWriterLock();
				}
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to add event handler!", exception);
				}
			}
        }

        public void AddHandlerUnique(RoadEvent e, RoadEventHandler del)
        {
			try
			{
				m_lock.AcquireWriterLock(3000);
				try
				{
					WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)m_events[e];
					if (weakDelegate == null)
					{
						m_events[e] = new WeakMulticastDelegate(del);
					}
					else
					{
						m_events[e] = WeakMulticastDelegate.CombineUnique(weakDelegate, del);
					}
				}
				finally
				{
					m_lock.ReleaseWriterLock();
				}
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to add event handler!", exception);
				}
			}
        }

        public void Notify(RoadEvent e)
        {
			Notify(e, null, null);
        }

        public void Notify(RoadEvent e, EventArgs args)
        {
			Notify(e, null, args);
        }

        public void Notify(RoadEvent e, object sender)
        {
			Notify(e, sender, null);
        }

        public void Notify(RoadEvent e, object sender, EventArgs eArgs)
        {
			try
			{
				m_lock.AcquireReaderLock(3000);
				WeakMulticastDelegate delegate2;
				try
				{
					delegate2 = (WeakMulticastDelegate)m_events[e];
				}
				finally
				{
					m_lock.ReleaseReaderLock();
				}
				delegate2?.InvokeSafe(new object[3]
				{
					e,
					sender,
					eArgs
				});
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to notify event handler!", exception);
				}
			}
        }

        public void RemoveAllHandlers()
        {
			try
			{
				m_lock.AcquireWriterLock(3000);
				try
				{
					m_events.Clear();
				}
				finally
				{
					m_lock.ReleaseWriterLock();
				}
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to remove all event handlers!", exception);
				}
			}
        }

        public void RemoveAllHandlers(RoadEvent e)
        {
			try
			{
				m_lock.AcquireWriterLock(3000);
				try
				{
					m_events.Remove(e);
				}
				finally
				{
					m_lock.ReleaseWriterLock();
				}
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to remove event handlers!", exception);
				}
			}
        }

        public void RemoveHandler(RoadEvent e, RoadEventHandler del)
        {
			try
			{
				m_lock.AcquireWriterLock(3000);
				try
				{
					WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)m_events[e];
					if (weakDelegate != null)
					{
						weakDelegate = WeakMulticastDelegate.Remove(weakDelegate, del);
						if (weakDelegate == null)
						{
							m_events.Remove(e);
						}
						else
						{
							m_events[e] = weakDelegate;
						}
					}
				}
				finally
				{
					m_lock.ReleaseWriterLock();
				}
			}
			catch (ApplicationException exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to remove event handler!", exception);
				}
			}
        }
    }
}
