namespace Game.Logic.Phy.Maths
{
    public class EulerVector
    {
        public float x0;

        public float x1;

        public float x2;

        public EulerVector(int x0, int x1, float x2)
        {
			this.x0 = x0;
			this.x1 = x1;
			this.x2 = x2;
        }

        public void clear()
        {
			x0 = 0f;
			x1 = 0f;
			x2 = 0f;
        }

        public void clearMotion()
        {
			x1 = 0f;
			x2 = 0f;
        }

        public void ComputeOneEulerStep(float m, float af, float f, float dt)
        {
			x2 = (f - af * x1) / m;
			x1 += x2 * dt;
			x0 += x1 * dt;
        }

        public string toString()
        {
			return "x:" + x0 + ",v:" + x1 + ",a" + x2;
        }
    }
}
