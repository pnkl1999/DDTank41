namespace Road.Base.Packets
{
    public class FSM
    {
        private int _adder;

        private int _mulitper;

        private int _state;

        public int count;

        public string name;

        public int getState()
        {
			return _state;
        }

        public int getAdder()
        {
			return _adder;
        }

        public int getMulitper()
        {
			return _mulitper;
        }

        public FSM(int adder, int mulitper, string objname)
        {
			name = objname;
			count = 0;
			_adder = adder;
			_mulitper = mulitper;
			UpdateState();
        }

        public void Setup(int adder, int mulitper)
        {
			_adder = adder;
			_mulitper = mulitper;
			UpdateState();
        }

        public int UpdateState()
        {
			_state = (~_state + _adder) * _mulitper;
			_state ^= _state >> 16;
			count++;
			return _state;
        }
    }
}
