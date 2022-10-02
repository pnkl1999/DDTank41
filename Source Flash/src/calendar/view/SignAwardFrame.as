package calendar.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class SignAwardFrame extends BaseAlerFrame
   {
       
      
      private var _back:DisplayObject;
      
      private var _awardCells:Vector.<SignAwardCell>;
      
      private var _awards:Array;
      
      private var _signCount:int;
      
      public function SignAwardFrame()
      {
         this._awardCells = new Vector.<SignAwardCell>();
         super();
         this.configUI();
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         ObjectUtils.disposeObject(this);
      }
      
      public function show(param1:int, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc7_:SignAwardCell = null;
         var _loc3_:Point = null;
         _loc4_ = 0;
         var _loc5_:int = 0;
         var _loc6_:DaylyGiveInfo = null;
         _loc7_ = null;
         this._signCount = param1;
         this._awards = param2;
         _loc3_ = ComponentFactory.Instance.creatCustomObject("Calendar.SignAward.TopLeft");
         _loc4_ = 0;
         _loc5_ = 0;
         for each(_loc6_ in this._awards)
         {
            _loc7_ = ComponentFactory.Instance.creatCustomObject("SignAwardCell");
            this._awardCells.push(_loc7_);
            _loc7_.info = ItemManager.Instance.getTemplateById(_loc6_.TemplateID);
            _loc7_.setCount(_loc6_.Count);
            if(_loc5_ % 2 == 0)
            {
               _loc7_.x = _loc3_.x;
               _loc7_.y = _loc3_.y + _loc4_ * 60;
            }
            else
            {
               _loc7_.x = _loc3_.x + 132;
               _loc7_.y = _loc3_.y + _loc4_ * 60;
               _loc4_++;
            }
            addToContent(_loc7_);
            _loc5_++;
         }
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function configUI() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.calendar.sign.title"),LanguageMgr.GetTranslation("ok"),"",true,false);
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignAward.Back");
         addToContent(this._back);
      }
      
      override public function dispose() : void
      {
         while(this._awardCells.length > 0)
         {
            ObjectUtils.disposeObject(this._awardCells.shift());
         }
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         super.dispose();
      }
   }
}
