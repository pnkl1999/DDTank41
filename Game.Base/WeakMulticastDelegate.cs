using log4net;
using System;
using System.Reflection;
using System.Text;

namespace Game.Base
{
    public class WeakMulticastDelegate
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private MethodInfo method;

        private WeakMulticastDelegate prev;

        private WeakReference weakRef;

        public WeakMulticastDelegate(Delegate realDelegate)
        {
			if (realDelegate.Target != null)
			{
				weakRef = new WeakRef(realDelegate.Target);
			}
			method = realDelegate.Method;
        }

        private WeakMulticastDelegate Combine(Delegate realDelegate)
        {
			WeakMulticastDelegate obj = new WeakMulticastDelegate(realDelegate)
			{
				prev = prev
			};
			WeakMulticastDelegate weakMulticastDelegate = obj;
			prev = obj;
			WeakMulticastDelegate delegate2 = weakMulticastDelegate;
			return this;
        }

        public static WeakMulticastDelegate Combine(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
			if ((object)realDelegate == null)
			{
				return null;
			}
			if (weakDelegate != null)
			{
				return weakDelegate.Combine(realDelegate);
			}
			return new WeakMulticastDelegate(realDelegate);
        }

        private WeakMulticastDelegate CombineUnique(Delegate realDelegate)
        {
			bool flag = Equals(realDelegate);
			if (!flag && prev != null)
			{
				WeakMulticastDelegate delegate2 = prev;
				while (!flag && delegate2 != null)
				{
					if (delegate2.Equals(realDelegate))
					{
						flag = true;
					}
					delegate2 = delegate2.prev;
				}
			}
			if (!flag)
			{
				return Combine(realDelegate);
			}
			return this;
        }

        public static WeakMulticastDelegate CombineUnique(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
			if ((object)realDelegate == null)
			{
				return null;
			}
			if (weakDelegate != null)
			{
				return weakDelegate.CombineUnique(realDelegate);
			}
			return new WeakMulticastDelegate(realDelegate);
        }

        public string Dump()
        {
			StringBuilder builder = new StringBuilder();
			WeakMulticastDelegate prev = this;
			int num = 0;
			while (prev != null)
			{
				num++;
				if (prev.weakRef == null)
				{
					builder.Append("\t");
					builder.Append(num);
					builder.Append(") ");
					builder.Append(prev.method.Name);
					builder.Append(Environment.NewLine);
				}
				else if (prev.weakRef.IsAlive)
				{
					builder.Append("\t");
					builder.Append(num);
					builder.Append(") ");
					builder.Append(prev.weakRef.Target);
					builder.Append(".");
					builder.Append(prev.method.Name);
					builder.Append(Environment.NewLine);
				}
				else
				{
					builder.Append("\t");
					builder.Append(num);
					builder.Append(") INVALID.");
					builder.Append(prev.method.Name);
					builder.Append(Environment.NewLine);
				}
				prev = prev.prev;
			}
			return builder.ToString();
        }

        protected bool Equals(Delegate realDelegate)
        {
			if (weakRef == null)
			{
				if (realDelegate.Target == null)
				{
					return method == realDelegate.Method;
				}
				return false;
			}
			if (weakRef.Target == realDelegate.Target)
			{
				return method == realDelegate.Method;
			}
			return false;
        }

        public void Invoke(object[] args)
        {
			for (WeakMulticastDelegate delegate2 = this; delegate2 != null; delegate2 = delegate2.prev)
			{
				int tickCount = Environment.TickCount;
				if (delegate2.weakRef == null)
				{
					delegate2.method.Invoke(null, args);
				}
				else if (delegate2.weakRef.IsAlive)
				{
					delegate2.method.Invoke(delegate2.weakRef.Target, args);
				}
				if (Environment.TickCount - tickCount > 500 && log.IsWarnEnabled)
				{
					log.Warn("Invoke took " + (Environment.TickCount - tickCount) + "ms! " + delegate2.ToString());
				}
			}
        }

        public void InvokeSafe(object[] args)
        {
			for (WeakMulticastDelegate delegate2 = this; delegate2 != null; delegate2 = delegate2.prev)
			{
				int tickCount = Environment.TickCount;
				try
				{
					if (delegate2.weakRef == null)
					{
						delegate2.method.Invoke(null, args);
					}
					else if (delegate2.weakRef.IsAlive)
					{
						delegate2.method.Invoke(delegate2.weakRef.Target, args);
					}
				}
				catch (Exception exception)
				{
					if (log.IsErrorEnabled)
					{
						log.Error("InvokeSafe", exception);
					}
				}
				if (Environment.TickCount - tickCount > 500 && log.IsWarnEnabled)
				{
					log.Warn("InvokeSafe took " + (Environment.TickCount - tickCount) + "ms! " + delegate2.ToString());
				}
			}
        }


		public static WeakMulticastDelegate operator +(WeakMulticastDelegate d, Delegate realD)
		{
			return Combine(d, realD);
		}

		public static WeakMulticastDelegate operator -(WeakMulticastDelegate d, Delegate realD)
		{
			return Remove(d, realD);
		}
        private WeakMulticastDelegate Remove(Delegate realDelegate)
        {
			if (Equals(realDelegate))
			{
				return this.prev;
			}
			WeakMulticastDelegate prev = this.prev;
			WeakMulticastDelegate delegate3 = this;
			while (prev != null)
			{
				if (prev.Equals(realDelegate))
				{
					delegate3.prev = prev.prev;
					prev.prev = null;
					break;
				}
				delegate3 = prev;
				prev = prev.prev;
			}
			return this;
        }

        public static WeakMulticastDelegate Remove(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
			if ((object)realDelegate == null || weakDelegate == null)
			{
				return null;
			}
			return weakDelegate.Remove(realDelegate);
        }

        public override string ToString()
        {
			Type declaringType = null;
			if (method != null)
			{
				declaringType = method.DeclaringType;
			}
			object target = null;
			if (weakRef != null && weakRef.IsAlive)
			{
				target = weakRef.Target;
			}
			return new StringBuilder(64).Append("method: ").Append((declaringType == null) ? "(null)" : declaringType.FullName).Append('.')
				.Append((method == null) ? "(null)" : method.Name)
				.Append(" target: ")
				.Append((target == null) ? "null" : target.ToString())
				.ToString();
        }
    }
}
