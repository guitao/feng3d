package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子缩放节点顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticleScaleGlobal extends FagalVertexMethod
	{
		[Register(regName = "particleScale_vc_vector", regType = "in", description = "粒子缩放数据")]
		public var scaleRegister:Register;

		[Register(regName = "inCycleTime_vt_4", regType = "in", description = "粒子周期内时间临时寄存器")]
		public var inCycleTimeTemp:Register;

		[Register(regName = "animatedPosition_vt_4", regType = "out", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;

		override public function runFunc():void
		{
			var temp:Register = getFreeTemp();

//			if (_usesCycle) {
//				code += "mul " + temp + "," + animationRegisterCache.vertexTime + "," + scaleRegister + ".z\n";
//				
//				if (_usesPhase)
//					code += "add " + temp + "," + temp + "," + scaleRegister + ".w\n";
//				
//				code += "sin " + temp + "," + temp + "\n";
//			}

			mul(temp, scaleRegister.y, inCycleTimeTemp.y); //计算  随时间增量  = 差值 * 本周期比例
			add(temp, scaleRegister.x, temp); //缩放值 = 最小值 + 随时间增量
			mul(animatedPosition.xyz, animatedPosition.xyz, temp); //缩放应用到顶点坐标上
		}
	}
}