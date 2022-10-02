package chickActivation.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   
   public class LevelPacksComponent extends Component
   {
       
      
      public var levelIndex:int;
      
      public var isGray:Boolean;
      
      public function LevelPacksComponent()
      {
         super();
         this.tipStyle = "chickActivation.view.ChickActivationTip";
         this.tipDirctions = "0,1,2,7,3,6";
         this.mouseChildren = false;
      }
      
      public function buttonGrayFilters(param1:Boolean) : void
      {
         if(param1)
         {
            this.buttonMode = false;
            this.isGray = false;
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this.buttonMode = true;
            this.isGray = true;
            this.filters = null;
         }
      }
   }
}
