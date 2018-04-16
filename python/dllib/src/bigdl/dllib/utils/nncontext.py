#
# Copyright 2018 Analytics Zoo Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from bigdl.util.common import *


def get_nncontext(conf=None):
    """
    Gets a SparkContext with optimized configuration for BigDL performance. The method
    will also initialize the BigDL engine.

    Note: if you use spark-shell or Jupyter notebook, as the Spark context is created
    before your code, you have to set Spark conf values through command line options
    or properties file, and init BigDL engine manually.

    :param conf: User defined Spark conf
    """

    sc = get_spark_context(conf)
    init_engine()
    return sc
