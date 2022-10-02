package ddt.states
{
   public interface IStateCreator
   {
       
      
      function create(param1:String) : BaseStateView;
      
      function createAsync(param1:String, param2:Function) : void;
   }
}
