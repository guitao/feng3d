package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子时间节点顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticlesTime extends FagalVertexMethod
	{
		[Register(regName = "particleTime_va_4", regType = "in", description = "粒子时间属性数据")]
		public var particleTimeVA:Register;

		[Register(regName = "particleTime_vc_vector", regType = "uniform", description = "特效当前时间")]
		public var particleTimeVC:Register;

		[Register(regName = "particleCommon_vc_vector", regType = "uniform", description = "粒子常数数据[0,1,2,0]")]
		public var particleCommon:Register;

		[Register(regName = "animatedPosition_vt_4", regType = "out", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;

		[Register(regName = "inCycleTime_vt_4", regType = "out", description = "粒子周期内时间临时寄存器")]
		public var inCycleTimeTemp:Register;
		
		override public function runFunc():void
		{
			var vt3:Register = getFreeTemp();

			//计算时间
			sub(inCycleTimeTemp.x, particleTimeVC, particleTimeVA.x); //生存了的时间  = 粒子特效时间 - 粒子出生时间
			sge(vt3.x, inCycleTimeTemp.x, particleCommon.x); //粒子是否出生  = 生存了的时间 [inCycleTimeTemp.x] > 0[particleCommon.x] ? 1 : 0
			mul(animatedPosition.xyz, animatedPosition.xyz, vt3.x); //粒子顶点坐标 = 粒子顶点坐标 * 粒子是否出生
			
			//处理循环
			mul(vt3.x, inCycleTimeTemp.x, particleTimeVA.w); //粒子生存的周期数 = 生存了的时间 * 周期倒数
			frc(vt3.x, vt3.x); //本周期比例 = 粒子生存的周期数取小数部分
			mul(inCycleTimeTemp.x, vt3.x, particleTimeVA.y); //周期内时间 = 本周期比例 * 周期 
			
			//计算周期数(vt2.y)
			mul(inCycleTimeTemp.y, inCycleTimeTemp.x, particleTimeVA.w);//本周期比例 = 周期内时间 * 周期倒数
		}
	}
}