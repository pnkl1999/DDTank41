using System;

namespace Game.Base
{
    public class WeakRef : WeakReference
    {
        private class NullValue
        {
        }

        private static readonly NullValue NULL = new NullValue();

        public override object Target
        {
			get
			{
				object target = base.Target;
				if (target != NULL)
				{
					return target;
				}
				return null;
			}
			set
			{
				base.Target = ((value == null) ? NULL : value);
			}
        }

        public WeakRef(object target)
			: base((target == null) ? NULL : target)
        {
        }

        public WeakRef(object target, bool trackResurrection)
			: base((target == null) ? NULL : target, trackResurrection)
        {
        }
    }
}
