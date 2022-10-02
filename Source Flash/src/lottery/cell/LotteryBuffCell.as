package lottery.cell
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class LotteryBuffCell extends BaseCell
   {
       
      
      private var _timeLimit:ScaleFrameImage;
      
      private var _buffName:ScaleFrameImage;
      
      public function LotteryBuffCell()
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,46,60);
         _loc1_.graphics.endFill();
         super(_loc1_);
         this.initII();
         this.addEvent();
      }
      
      private function initII() : void
      {
         this._timeLimit = ComponentFactory.Instance.creatComponentByStylename("lottery.buffCell.timeLimit");
         addChild(this._timeLimit);
         this._buffName = ComponentFactory.Instance.creatComponentByStylename("lottery.buffCell.buffName");
         addChild(this._buffName);
         PicPos = new Point(-3,-6);
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.CHANGE,this.__infoChange);
      }
      
      private function __infoChange(param1:Event) : void
      {
         this._buffName.visible = true;
         switch(_info.TemplateID)
         {
            case EquipType.PREVENT_KICK:
               this._buffName.visible = false;
               break;
            case EquipType.DOUBLE_GESTE_CARD:
               this._buffName.setFrame(2);
               break;
            case EquipType.DOUBLE_EXP_CARD:
               this._buffName.setFrame(1);
               break;
            case EquipType.FREE_PROP_CARD:
               this._buffName.visible = false;
               break;
            default:
               this._buffName.visible = false;
         }
      }
      
      public function set timeLimit(param1:int) : void
      {
         this._timeLimit.setFrame(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(Event.CHANGE,this.__infoChange);
         if(this._buffName)
         {
            ObjectUtils.disposeObject(this._buffName);
         }
         this._buffName = null;
         if(this._timeLimit)
         {
            ObjectUtils.disposeObject(this._timeLimit);
         }
         this._timeLimit = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
