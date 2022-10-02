package ddt.interfaces
{
   import com.pickgliss.ui.core.Disposeable;
   
   public interface IProcessObject extends Disposeable
   {
       
      
      function get onProcess() : Boolean;
      
      function set onProcess(param1:Boolean) : void;
      
      function process(param1:Number) : void;
   }
}
