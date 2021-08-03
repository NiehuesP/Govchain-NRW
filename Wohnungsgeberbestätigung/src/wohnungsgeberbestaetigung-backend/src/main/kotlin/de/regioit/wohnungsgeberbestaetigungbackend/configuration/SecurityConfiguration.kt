package de.regioit.wohnungsgeberbestaetigungbackend.configuration

import de.regioit.wohnungsgeberbestaetigungbackend.security.jwt.JWTConfigurer
import de.regioit.wohnungsgeberbestaetigungbackend.security.jwt.TokenProvider
import org.springframework.beans.factory.BeanInitializationException
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Import
import org.springframework.http.HttpMethod
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.builders.WebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.DelegatingPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.data.repository.query.SecurityEvaluationContextExtension
import org.zalando.problem.spring.web.advice.security.SecurityProblemSupport
import java.util.*
import javax.annotation.PostConstruct
import javax.sql.DataSource

@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Import(SecurityProblemSupport::class)
class SecurityConfiguration(private val authenticationManagerBuilder: AuthenticationManagerBuilder,
                            private val tokenProvider: TokenProvider,
                            private val dataSource: DataSource) : WebSecurityConfigurerAdapter() {

    @PostConstruct
    fun init() {
        try {
            authenticationManagerBuilder
                    .userDetailsService(userDetailsService())
                    .passwordEncoder(passwordEncoder())
        } catch (e: Exception) {
            throw BeanInitializationException("Security configuration failed", e)
        }
    }

    @Bean
    @Throws(Exception::class)
    override fun authenticationManagerBean(): AuthenticationManager {
        return super.authenticationManagerBean()
    }

    @Bean
    fun passwordEncoder(): PasswordEncoder {
        val idForEncode = "bcrypt"
        return DelegatingPasswordEncoder(idForEncode, Collections.singletonMap(idForEncode, BCryptPasswordEncoder()) as Map<String, PasswordEncoder>?)
    }

    @Throws(Exception::class)
    override fun configure(web: WebSecurity) {
        web.ignoring()
                .antMatchers(HttpMethod.OPTIONS, "/**")
                .antMatchers("/h2-console/**")
    }

    @Throws(Exception::class)
    override fun configure(http: HttpSecurity) {
        http
                .csrf()
                .disable()
                .exceptionHandling()
                .and()
                .headers()
                .frameOptions()
                .disable()
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .antMatchers("/api/authenticate").permitAll()
                .antMatchers("/api/socket/**").permitAll() // TODO Fix me
                .antMatchers("/api/**").permitAll()
                .antMatchers("/management/health").permitAll()
                .antMatchers("/management/info").permitAll()
                .antMatchers("/management/**").hasAuthority("ROLE_ADMIN")
                .and()
                .apply(securityConfigurerAdapter())
    }

    private fun securityConfigurerAdapter(): JWTConfigurer {
        return JWTConfigurer(tokenProvider)
    }

    @Bean
    override fun userDetailsService(): UserDetailsService {
        val jdbcDao = JdbcDaoImpl()
        jdbcDao.setDataSource(dataSource)
        jdbcDao.usersByUsernameQuery = "select username,password, 'true' as enabled from app_user where username = ?"
        jdbcDao.setAuthoritiesByUsernameQuery("select username,role_name from app_user where username = ?")
        return jdbcDao
    }

    @Bean
    fun securityEvaluationContextExtension(): SecurityEvaluationContextExtension? {
        return SecurityEvaluationContextExtension()
    }
}
