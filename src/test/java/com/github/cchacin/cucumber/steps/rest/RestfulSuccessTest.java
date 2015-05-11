/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.github.cchacin.cucumber.steps.rest;

import com.github.cchacin.cucumber.steps.CallsSteps;
import com.github.cchacin.cucumber.steps.DatabaseSteps;
import com.github.cchacin.cucumber.steps.RedisKeyValueSteps;
import com.github.cchacin.cucumber.steps.RedisListSteps;
import com.github.cchacin.cucumber.steps.RestSteps;
import cucumber.runtime.arquillian.ArquillianCucumber;
import cucumber.runtime.arquillian.api.Features;
import cucumber.runtime.arquillian.api.Glues;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.WebArchive;
import org.junit.runner.RunWith;

@Glues({RestSteps.class, DatabaseSteps.class, CallsSteps.class, RedisKeyValueSteps.class, RedisListSteps.class})
@Features({
        "features/successful-endpoints.feature",
        "features/redis.feature"
})
@RunWith(ArquillianCucumber.class)
public class RestfulSuccessTest {

    @Deployment(testable = false)
    public static Archive<?> createDeployment() {
        return ShrinkWrap.create(WebArchive.class, "test-app.war")
                .addPackages(true, "com.github.cchacin.cucumber.steps")
                .addAsWebInfResource(EmptyAsset.INSTANCE, "beans.xml")
                .addAsManifestResource("test-persistence.xml", "persistence.xml")
                .addAsWebInfResource("test-resources.xml", "resources.xml")
                .addAsWebInfResource("test-openejb-jar.xml", "openejb-jar.xml");

    }
}
